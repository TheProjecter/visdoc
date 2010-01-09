package VisDoc::ParserBase;

use strict;
use VisDoc::StringUtils;
use VisDoc::ClassData;
use VisDoc::MemberData;
use VisDoc::MethodData;
use VisDoc::PropertyData;
use VisDoc::PackageData;
use VisDoc::ParameterData;

#use Scalar::Util qw(refaddr);    # for testing object equality

# implemented by subclasses:
our $ID = '';

=pod

=cut

sub getLanguageId {
    my ($inText) = @_;

    return $VisDoc::Defaults::NOT_IMPLEMENTED;
}

### INSTANCE MEMBERS ###

=pod

=cut

sub new {
    my ( $class, $inFileParser ) = @_;
    my $this = {};
    $this->{fileParser} =
      $inFileParser;    # ref to FileParser object (that owns all string stubs)

    $this->{PATTERN_PACKAGE}                   = '';
    $this->{PATTERN_CLASS_NAME}                = '';
    $this->{PATTERN_METHOD_NAME}               = '';
    $this->{PATTERN_CLASS_LINE_WITH_JAVADOC}   = '';
    $this->{MAP_CLASS_LINE_WITH_JAVADOC}       = '';
    $this->{PATTERN_METADATA_CONTENTS}         = '';
    $this->{PATTERN_KEY_IS_VALUE}              = '';
    $this->{PATTERN_METHOD_WITH_JAVADOC}       = '';
    $this->{MAP_METHOD_WITH_JAVADOC}           = undef;
    $this->{PATTERN_PARAMETER}                 = '';
    $this->{PATTERN_PROPERTY_WITH_JAVADOC}     = '';
    $this->{MAP_PROPERTY_WITH_JAVADOC}         = undef;
    $this->{PATTERN_MULTILINE_PROPERTY_OBJECT} = '';
    $this->{PATTERN_NAME_TYPE_VALUE}           = '';
    $this->{PATTERN_ARRAY}                     = '';
    $this->{PATTERN_INCLUDE}                   = '';

    bless $this, $class;
    return $this;
}

=pod

parseClasses($text) -> (\@classData, $text)

=cut

sub parseClasses {
    my ( $this, $inText ) = @_;

    my ( $classes, $text ) = $this->_parseClasses($inText);
    $this->{classes} = $classes;
    return ( $classes, $text );
}

=pod

resolveIncludes( $text ) -> $text

Adds included files to the text.
 
To be implemented by subclasses.

=cut

sub resolveIncludes {
    my ( $this, $inText ) = @_;
    return $inText;
}

=pod

retrievePackageName( $text ) -> $name

Reads the package name from the text. Text must be clean from comments.
 
To be implemented by subclasses.

=cut

sub retrievePackageName {
    my ( $this, $inText ) = @_;

    return $VisDoc::Defaults::NOT_IMPLEMENTED;
}

sub composeClasspath {
    my ( $this, $inPackage, $inClassName ) = @_;
	
	my @components = ();
	push (@components, $inPackage) if $inPackage;
	push (@components, $inClassName) if $inClassName;
	return '' if !scalar @components;
	return join (".", @components);
}

=pod

parsePackage($fileData, $text, $languageId, \@classes) -> $packageData

=cut

sub parsePackage {
    my ( $this, $inFileData, $inText, $inLanguageId, $inClasses ) = @_;

    # create storage object
    my VisDoc::PackageData $packageData = VisDoc::PackageData->new();
    $packageData->{classes} = $inClasses;

    my $javadocStub = $this->_getPackageJavadocString($inText);
    if ($javadocStub) {
        my $javadoc = $this->{fileParser}->parseJavadoc($javadocStub);
        $packageData->{javadoc} = $javadoc;
    }

    my $packageName = $this->retrievePackageName($inText);
    $packageData->{name} = $packageName;

    my ( $functions, $properties, $text ) = $this->_parseMembers($inText);
    $packageData->{functions} = $functions;

    $this->_postProcessPackageData( $packageData, $inFileData );

    return $packageData;
}

=pod

_getPackageJavadocString( $text ) -> $javadocStub

=cut

sub _getPackageJavadocString {
    my ( $this, $inText ) = @_;

    my $javadocStub    = '';
    my $packagePattern = $this->{PATTERN_PACKAGE};

    return '' if !$packagePattern;
    my $result = $inText =~ m/$packagePattern/x;
    $javadocStub = $1 if $result && $1;

    return $javadocStub;
}

=pod

_isPublic( \@access ) -> $bool

Checks access list if class or member is public.
To be implemented by subclasses.

=cut

sub _isPublic {
    my ( $this, $inAccess ) = @_;

    return 0;
}

=pod

_parseClasses() -> \@classData

=cut

sub _parseClasses {
    my ( $this, $inText ) = @_;

    my ( $text, $classes ) = $this->_parseClassData($inText);

=pod
    use Data::Dumper;
    print( " classes=" . Dumper($classes) . "\n" );
    print( " class count=" . @$classes . "\n" );
    print(" text=$text\n");
=cut

    foreach my $classData (@$classes) {

    	$this->_postProcessClassData( $classData );

        my $classText = $classData->{working_contents};

        # dispose of temporary class text
        delete $classData->{working_contents};
        my ( $methods, $properties, $text ) = $this->_parseMembers($classText);

        $this->_postProcessMethodData( $classData, $methods );
        $this->_postProcessPropertyData( $classData, $properties );

        $classData->{methods}    = $methods;
        $classData->{properties} = $properties;
    }
    return ( $classes, $text );
}

=pod

_parseClassData($text, \$outerClassData, \@classes) -> ($text, \@classData)

=cut

sub _parseClassData {
    my ( $this, $inText, $inOuterClass, $inClasses ) = @_;

    # pass classes if called recursively
    my $classes = $inClasses;

    my ( $pattern, $patternMap ) = $this->_getParseClassRegexData();

    my $text = $inText;
    local $_ = $text;
    my @matches = /$pattern/x;

    if ( scalar @matches ) {
        my $lastChar = '';
        ( $classes, my $data ) =
          $this->_handleClassMatches( \@matches, $classes, $patternMap );

        # enclosingClass
        if ( defined $inOuterClass ) {
            $data->{enclosingClass} = $inOuterClass;
			$data->{isInnerClass} = 1;
			
            # also set inner class
            push @{ $inOuterClass->{innerClasses} }, $data;
            
            # set classpath
            $data->{classpath} = $this->composeClasspath($inOuterClass->{packageName}, $data->{name} );
        }
        else {

            # set class package
            my $package = $this->retrievePackageName($text);
            $data->{packageName} = $package;
            $data->{classpath} =
              $this->_createClasspath( $package,
                $data->{name} );
        }

        # super classpaths
        if ( defined $data->{superclasses} ) {
            map {
                $_->{classpath} =
                  $this->_getClasspathFromImports( $_->{name}, $inText );
            } @{ $data->{superclasses} };
        }

        # prepare the fetching and removal of class contents
        my $startLoc = $-[0];
        my $endLoc =
             $+[0]
          || $-[0]
          || 0;    # default, in case the method string does not have braces
        pos = $startLoc;    # start from beginning of match

        use Regexp::Common qw( RE_balanced );
        my $balanced = RE_balanced( -parens => '{}', -keep );
        if (/$balanced/gcosx) {
            my $contents = $1;

            # clean up
            $contents =~ s/^{[[:space:]]*(.*?)[[:space:]]*}$/$1/s;

            $data->{working_contents} = $contents;

            # remove class contents from text
            my $stripped = substr( $text, $startLoc, pos() - $startLoc,
                "\nVISDOC_STRIPPED_CLASS" );

            #print("stripped=$stripped\n");
            #print("DEEPER\n");

            # parse class contents
            my ( $text, $classes ) =
              $this->_parseClassData( $contents, $data, $classes );
        }

        #print("SAME LEVEL\n");

        # repeat parsing in case there is next class at the same level
        ( $text, $classes ) =
          $this->_parseClassData( $text, $inOuterClass, $classes );
    }
    return ( $text, $classes );
}

=pod

=cut

sub _createClasspath {
    my ( $this, $inPackageName, $inClassName ) = @_;

    my @components = ();
    push( @components, $inPackageName ) if $inPackageName;
    push( @components, $inClassName )   if $inClassName;

    return join( '.', @components );
}

=pod

_handleClassMatches (@matches, \@classes, $patternMap) -> (\@classData, $classData)

=cut

sub _handleClassMatches {
    my ( $this, $inMatches, $inClasses, $inPatternMap ) = @_;

    my VisDoc::ClassData $classData = VisDoc::ClassData->new();
    push @{$inClasses}, $classData;

    my $data = $classData;

    # set properties

    my $i;    # match index

    # javadoc
    $i = $inPatternMap->{javadoc} - 1;
    if ( defined $inMatches->[$i] ) {

        #$data->{javadocStub} = $inMatches->[$i];
        $data->{javadoc} =
          $this->{fileParser}->parseJavadoc( $inMatches->[$i] );
    }

    # access
    $i = $inPatternMap->{access} - 1;
    if ( defined $inMatches->[$i] ) {
        my $accessStr = $inMatches->[$i];
        if ($accessStr) {
            my @access = $this->_parseClassAccess($accessStr);
            $data->{access} = \@access if scalar @access;
        }
    }
    $data->{isAccessPublic} = $this->_isPublic( $data->{access} );

    # type
    $i = $inPatternMap->{type} - 1;
    if ( defined $inMatches->[$i] ) {
        my $typeStr = $inMatches->[$i];
        $data->{type} = $VisDoc::ClassData::TYPE->{'CLASS'}
          if $typeStr eq 'class';
        $data->{type} = $VisDoc::ClassData::TYPE->{'INTERFACE'}
          if $typeStr eq 'interface';
    }

    # name
    $i = $inPatternMap->{name} - 1;
    if ( defined $inMatches->[$i] ) {
        my $nameStr = $inMatches->[$i];
        $data->{name} = $this->_parseClassName($nameStr);
    }

    # superclasses
    $i = $inPatternMap->{superclasses} - 1;
    if ( defined $inMatches->[$i] ) {
        my $superclassesStr = $inMatches->[$i];
        my $superclassNames = $this->_parseSuperclassNames($superclassesStr);
        $data->setSuperclassNames($superclassNames);
    }

    # interfaces
    $i = $inPatternMap->{interfaces} - 1;
    if ( defined $inMatches->[$i] ) {
        my $interfacesStr  = $inMatches->[$i];
        my $interfaceNames = $this->_parseInterfaceNames($interfacesStr);
        $data->setInterfaceNames($interfaceNames);
    }

    return ( $inClasses, $data );
}

=pod

To be implemented by subclasses.

_getParseClassRegexData() -> ($pattern, \%patternMap)

Returns a tuple with
	- class pattern
	- reference to hash with keys/values:
		class_definition_part => pattern_index

=cut

sub _getParseClassRegexData {
    my ($this) = @_;

    return (
        $this->{PATTERN_CLASS_LINE_WITH_JAVADOC},
        $this->{MAP_CLASS_LINE_WITH_JAVADOC}
    );
}

=pod

_parseSuperclassNames($text) -> \@names

Returns a list of superclass names from a string with (optionally) multiple values separated by commas.

=cut

sub _parseSuperclassNames {
    my ( $this, $inText ) = @_;

    my @names =
      VisDoc::StringUtils::listFromKeywordWithCommaDelimitedString( $inText,
        'extends' );
    return \@names;
}

=pod

_parseImportClassPathForName( $className, $text ) -> $text

Returns the classpath for the class $className as written after 'import'.
Happens to be the same for as2, as3 and java.

=cut

sub _getClasspathFromImports {
    my ( $this, $inClassName, $inText ) = @_;

    my $pattern = "import[[:space:]]+([^;]*\\b$inClassName\\b)";
    if ( $inText =~ m/$pattern/ ) {
        return $1;
    }
    return undef;
}

=pod

_parseInterfaceNames($text) -> \@names

Returns a list of interfaces from a string with (optionally) multiple values separated by commas.

=cut

sub _parseInterfaceNames {
    my ( $this, $inText ) = @_;

    my @names =
      VisDoc::StringUtils::listFromKeywordWithCommaDelimitedString( $inText,
        'implements' );
    return \@names;
}

=pod

_parseClassAccess($text) -> @list

Returns a list of access keywords from a string with (optionally) multiple values separated by commas.

=cut

sub _parseClassAccess {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $text = $inText;
    VisDoc::StringUtils::trimSpaces($text);

    my @list =
      VisDoc::StringUtils::commaSeparatedListFromSpaceSeparatedString($text);

    return @list;
}

=pod

_parseClassName($text) -> $name

=cut

sub _parseClassName {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $text = $inText;
    VisDoc::StringUtils::trimSpaces($text);

    my @components = split( /\./, $text );
    my $name = $components[ scalar @components - 1 ] || $text;

    return $name;
}

sub _parseMembers {
    my ( $this, $inText ) = @_;

    my $text = $inText;

    ( $text, my $methods ) =
      $this->_parseMethods($text);    # objects of type MethodData
    $text = $this->_preparePropertyParsing($text);
    ( $text, my $properties ) =
      $this->_parseProperties($text);    # objects of type PropertyData

    $this->_setMemberOrder( $text, $methods, $properties );
    $this->_swapPropertyGetSetters( $methods, $properties );

    #use Data::Dumper;
    #print( " methods=" . Dumper($methods) . "\n" );
    #print( " properties=" . Dumper($properties) . "\n" );
    #print( " properties count=" . @$properties . "\n" );
    #print(" text=$text\n");

    return ( $methods, $properties, $text );
}

=pod

_swapPropertyGetSetters( \@methods, \@properties)

Moves property getters and setters from the methods list to the property list.

=cut

sub _swapPropertyGetSetters {
    my ( $this, $inMethods, $inProperties, $inCount ) = @_;

    my $count = 0;
    foreach my $method ( @{$inMethods} ) {

        if ( $method->{type} ) {

            # create new property
            my $propertyData = VisDoc::PropertyData->new();
            $propertyData->{type}        = $method->{type};
            $propertyData->{memberOrder} = $method->{memberOrder};
            $propertyData->{name}        = $method->{name};
            $propertyData->{access}      = $method->{access};
            $propertyData->{javadoc}     = $method->{javadoc};
            $propertyData->{metadata}    = $method->{metadata};

            $propertyData->{dataType} = $method->{returnType}
              if ( $method->{type} eq $VisDoc::MemberData::TYPE->{'READ'} );
            $propertyData->{dataType} = $method->{parameters}->[0]->{type}
              if ( $method->{type} eq $VisDoc::MemberData::TYPE->{'WRITE'} );

            push @{$inProperties}, $propertyData;
            my $deleted = splice( @{$inMethods}, $count, 1 );
            $this->_swapPropertyGetSetters( $inMethods, $inProperties );
        }
        $count++;
    }

    # sort properties
    if ( $inProperties && scalar @{$inProperties} ) {
        @{$inProperties} =
          sort { $a->{memberOrder} <=> $b->{memberOrder} } @{$inProperties};
    }
}

=pod

_setMemberOrder( $text, \@methods, \@properties)

Assigns a unique and incrementing 'memberOrder' id to each member, based on the order of the remainging text stubs STRIPPED_PROPERTY_0 and STRIPPED_METHOD_0.
The member order will later be used in output listings.

=cut

sub _setMemberOrder {
    my ( $this, $inText, $inMethods, $inProperties ) = @_;

    my $pattern = 'STRIPPED_(PROPERTY|METHOD)_([0-9]+)';

    local $_ = $inText;
    my $memberOrder = 0;
    while ( $inText =~ m/$pattern/xg ) {
        my $type = $1;
        my $id   = $2;
        my $member;
        if ( $type eq 'PROPERTY' ) {
            $member = $this->_getMemberWithId( $inProperties, $id );
        }
        elsif ( $type eq 'METHOD' ) {
            $member = $this->_getMemberWithId( $inMethods, $id );
        }
        if ($member) {
            $member->{memberOrder} = $memberOrder++;
        }
    }
}

=pod

_getMemberWithId( \@collection, $id ) -> $methodData or $propertyData

=cut

sub _getMemberWithId {
    my ( $this, $inCollection, $inId ) = @_;

    foreach my $member ( @{$inCollection} ) {
        if ( $member->{_id} eq $inId ) {
            return $member;
        }
    }
}

=pod

_parseMethods($text, \@methods) -> ($text, \@memberData)

=cut

sub _parseMethods {
    my ( $this, $inText, $inMethods ) = @_;

    my $methods    = $inMethods;
    my $pattern    = $this->{PATTERN_METHOD_WITH_JAVADOC};
    my $patternMap = $this->{MAP_METHOD_WITH_JAVADOC};

=pod
print("_parseMethods inText=$inText\n");
print("pattern=" . VisDoc::StringUtils::stripCommentsFromRegex($pattern) . "\n");
print("======================\n");
=cut

    my $text = $inText;
    local $_ = $text;
    use re 'eval';    # to be able to use Eval-group in pattern

    my @matches = /$pattern/x;

    if ( scalar @matches ) {
        my $lastChar = '';
        ( $methods, $lastChar ) =
          $this->_handleMethodMatches( \@matches, $methods, $patternMap );

        # prepare the fetching and removal of method string
        my $startLoc = $-[0];
        my $endLoc =
             $+[0]
          || $-[0]
          || 0;    # default, in case the method string does not have braces
        pos = $startLoc;    # start from beginning of match

        # method declaration or definition?
        # method declaration strings end on '{'
        if ( $lastChar eq '{' ) {
            use Regexp::Common qw( RE_balanced );
            my $balanced = RE_balanced( -parens => '{}', -keep );
            if (/$balanced/gcosx) {
                $endLoc = pos();
            }
        }

        # remove method declaration plus contents from text
        # add semi-colon because this is eaten by regex
        my $order    = scalar @{$methods} - 1;
        my $stripped = substr(
            $text, $startLoc,
            $endLoc - $startLoc,
            "; STRIPPED_METHOD_$order\n"
        );

        #print("\t stripped=$stripped\n");

        die(
"Infinite recursion while parsing:$inText\nPlease check the syntax of this code."
        ) if ( $text eq $inText );

        # repeat parsing in case there is next class at the same level
        ( $text, $methods ) = $this->_parseMethods( $text, $methods );
    }
    return ( $text, $methods );
}

=pod

_handleMethodMatches (@matches, \@methods, $patternMap) -> (\@methodData, $lastChar)

To be implemented by subclasses

=cut

sub _handleMethodMatches {
    my ( $this, $inMatches, $inMethods, $inPatternMap ) = @_;

    return ( undef, undef );
}

=pod

_parseMemberAccess($text) -> @list

Returns a list of access keywords from a string with (optionally) multiple values separated by commas.

=cut

sub _parseMemberAccess {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $text = $inText;
    VisDoc::StringUtils::trimSpaces($text);

    my @list =
      VisDoc::StringUtils::commaSeparatedListFromSpaceSeparatedString($text);
    return @list;
}

=pod

_parseMethodName($text) -> $name

=cut

sub _parseMethodName {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $text = $inText;
    VisDoc::StringUtils::trimSpaces($text);

    return $text;
}

=pod

_parseMethodType($text) -> $type

=cut

sub _parseMethodType {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $rawType = $inText;
    VisDoc::StringUtils::trimSpaces($rawType);

    return $rawType;
}

=pod

_parseMethodParameters($text) -> \@list

=cut

sub _parseMethodParameters {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $text = $inText;
    VisDoc::StringUtils::trimSpaces($text);

    $text = $this->{fileParser}->getContents($text);
    my @list =
      VisDoc::StringUtils::commaSeparatedListFromCommaSeparatedString($text);

    my $parameterDataList = $this->_parseMethodParameterData( \@list );
    return $parameterDataList;
}

=pod

_parseMethodParameterData(\@list) -> \@parameterData

Creates a list of ParameterData objects, read from a list of parameter strings.

To be implemented by subclass

=cut

sub _parseMethodParameterData {

    #    my ( $this, $inList ) = @_;

    return undef;
}

=pod

_parseMethodReturnType($text) -> \@list

=cut

sub _parseMethodReturnType {
    my ( $this, $inText ) = @_;

    # strip spaces
    my $text = $inText;
    VisDoc::StringUtils::trimSpaces($text);

    return $text;
}

=pod

_parseMetadataData($text) -> \@metadataList

To be implemented by subclass

=cut

sub _parseMetadataData {

    #    my ( $this, $inText ) = @_;

    return \();
}

=pod

Prepare formatting of text.
Optionally to be implemented by subclasses.

=cut

sub _preparePropertyParsing {
    my ( $this, $inText ) = @_;

    return $inText;
}

=pod

To be implemented by subclasses.

=cut

sub _splitOutOneLineProperty {
    my ( $this, $inMatches, $inPatternMap ) = @_;

    return undef;
}

=pod

_parseProperties( $text, \@properties ) -> ($text, \@propertyData)

=cut

sub _parseProperties {
    my ( $this, $inText, $inProperties ) = @_;

    my $properties = $inProperties;
    my $pattern    = $this->{PATTERN_PROPERTY_WITH_JAVADOC};
    my $patternMap = $this->{MAP_PROPERTY_WITH_JAVADOC};

=pod
	print("_parseProperties inText=$inText\n");
    print(  "_parseProperties pattern="
          . VisDoc::StringUtils::stripCommentsFromRegex($pattern)
          . "\n" );
    print(" ======================\n");
=cut

    my $text = $inText;
    local $_ = $text;
    my @matches = m/$pattern/sx;

    if ( scalar @matches ) {
        $properties =
          $this->_handlePropertyMatches( \@matches, $properties, $patternMap );

        # prepare the fetching and removal of property string
        my $startLoc = $-[0] || 0;
        my $endLoc = $+[0] || $-[0] || 0;

        # remove method declaration plus contents from text
        # add semi-colon because this is eaten by regex
        my $order    = scalar @{$properties} - 1;
        my $stripped = substr(
            $text, $startLoc,
            $endLoc - $startLoc,
            "; STRIPPED_PROPERTY_$order;\n"
        );

        #print("stripped=$stripped\n");

        ( $text, my $dummy ) = $this->_parseProperties( $text, $properties );
    }
    return ( $text, $properties );
}

=pod

_handlePropertyMatches (@matches, $properties, $patternMap) -> \@properties

To be implemented by subclasses.

=cut

sub _handlePropertyMatches {
    my ( $this, $inMatches, $inProperties, $inPatternMap ) = @_;

    return undef;
}

=pod

_parsePropertyName($text) -> $name

To be implemented by subclasses.

=cut

sub _parsePropertyName {
    my ( $this, $inText ) = @_;

    return $inText;
}

=pod

To be implemented by subclasses.

=cut

sub _parsePropertyType {
    my ( $this, $inText ) = @_;

    return 0;
}

=pod

_parsePropertyDataType($text) -> $type

To be implemented by subclasses.

=cut

sub _parsePropertyDataType {
    my ( $this, $inText ) = @_;

    return $inText;
}

=pod

_parsePropertyValue($text) -> $text

To be implemented by subclasses.

=cut

sub _parsePropertyValue {
    my ( $this, $inText ) = @_;

    return $inText;
}

=pod

_postProcessPackageData( $packageData, $fileData )

To be implemented by subclasses.

=cut

sub _postProcessPackageData {
    my ( $this, $inPackageData, $inFileData ) = @_;

    # ...
}

=pod

_postProcessClassData( $classData )

To be implemented by subclasses.

=cut

sub _postProcessClassData {
    my ( $this, $inClassData ) = @_;

    # ...
}

=pod

_postProcessMethodData( $classData, \@methodData )

Type: interprets whether methods are:
- constructor
- class method
- instance method
and sets these values in property 'type'.

=cut

sub _postProcessMethodData {
    my ( $this, $inClassData, $inMethods ) = @_;

    foreach my $methodData (@$inMethods) {

        my $type = $methodData->{type};

        # is constructor?
        $type |= $VisDoc::MemberData::TYPE->{'CONSTRUCTOR_MEMBER'}
          if $methodData->{name} eq $inClassData->{name};

        # is class method?
        if ( grep { $_ eq 'static' } @{ $methodData->{access} } ) {
            $type |= $VisDoc::MemberData::TYPE->{'CLASS_MEMBER'};
        }
        else {
            $type |= $VisDoc::MemberData::TYPE->{'INSTANCE_MEMBER'};
        }
        $methodData->{type} = $type;
    }
}

=pod

_postProcessPropertyData( $classData, \@propertyData )

Type: interprets whether properties are:
- class property
- instance property
and sets these values in property 'type'.

=cut

sub _postProcessPropertyData {
    my ( $this, $inClassData, $inProperties ) = @_;

    foreach my $propertyData (@$inProperties) {

        my $type = $propertyData->{type};

        # is class method?
        if ( grep { $_ eq 'static' } @{ $propertyData->{access} } ) {
            $type |= $VisDoc::MemberData::TYPE->{'CLASS_MEMBER'};
        }
        else {
            $type |= $VisDoc::MemberData::TYPE->{'INSTANCE_MEMBER'};
        }
        $propertyData->{type} = $type;

    }
}

sub _stubObjectProperties {
    my ( $this, $inPre, $inText, $inPost ) = @_;

	#return '' if !$inText;
	
    $inPre  |= '';
    $inPost |= '';

    my $pattern = '^({.*?})$';
    my ( $newText, $blocks ) = VisDoc::StringUtils::replacePatternMatchWithStub(
        \$inText, $pattern, 0, 1,
        $VisDoc::StringUtils::VERBATIM_STUB_PROPERTY_OBJECT,
        \$VisDoc::FileData::stubCounter
    );
        
	print "inPre=$inPre; inText=$inText; inPost=$inPost; newText=$newText\n";
    return "$inPre$inText$inPost" if !$newText;

    my $merged = $_[0]->{fileParser}->{data}->mergeData(
        VisDoc::FileData::getDataKey(
            $VisDoc::StringUtils::VERBATIM_STUB_PROPERTY_OBJECT),
        $blocks
    );
    $_[0]->{fileParser}->{data}->{objectProperties} = $merged;

    return "$inPre$newText;$inPost";
}

1;
