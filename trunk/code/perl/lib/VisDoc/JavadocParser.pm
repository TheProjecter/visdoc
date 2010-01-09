package VisDoc::JavadocParser;

use strict;

use VisDoc::JavadocData;
use VisDoc::StringUtils;
use VisDoc::FieldData;
use VisDoc::LinkData;
use VisDoc::HashUtils;

=pod

=cut

sub new {
    my ($class) = @_;
    my $this = {};
    $this = { data => VisDoc::JavadocData->new(), };
    bless $this, $class;
    return $this;
}

=pod

parse( $text, $fileData ) -> $javadocData

=cut

sub parse {
    my ( $this, $inText, $inFileData ) = @_;

    return if !$inText;

    my $text = $inText;
    VisDoc::StringUtils::removeStarsInJavadoc($text);

    my $linkTags = $this->_processInlineLinkTags( $inText, $inFileData );
    $this->{data}->{linkTags} = $linkTags if $linkTags;

    my ( $firstLine, $fieldNameParts ) = $this->_getFieldNameParts($text);

    my ( $fields, $paramFields ) =
      $this->_processFields( $fieldNameParts, $inFileData );

    $this->{data}->{fields} = $fields      if defined $fields;
    $this->{data}->{params} = $paramFields if defined $paramFields;

    if ($firstLine) {
        VisDoc::StringUtils::trimSpaces($firstLine);
        my VisDoc::FieldData $descriptionField =
          VisDoc::FieldData->new( $VisDoc::JavadocData::FIELD_DESCRIPTION,
            $firstLine );
        unshift( @{ $this->{data}->{fields} }, $descriptionField );
    }

    return $this->{data};
}

=pod

_processInlineLinkTags( $text, $fileData ) -> \@linkData

Finds occurrences of %VISDOC_STUB_INLINE_LINK_n% stubs in the text and creates LinkData objects.

Does NOT replace stubs with text yet.

Returns a list of FieldData objects.

=cut

sub _processInlineLinkTags {
    my ( $this, $inText, $inFileData ) = @_;

    my $pattern = VisDoc::StringUtils::getStubKeyPattern(
        $VisDoc::StringUtils::STUB_INLINE_LINK);
    my @fields;    # array ref

	my $createLinkField = sub {
		my ( $inStub ) = @_;
		my $value = $inFileData->getContentsOfLinkStub($inStub);
    	my $field = $inFileData->createAndStoreInlineLinkData($value, $inStub);
    	push( @fields, $field );
	};
	
    while ( $inText =~
        s/($pattern)/&$createLinkField($1)/ge ) {}

    return \@fields;
}

=pod

_createLinkData( $fieldName, $value) -> $linkData

Parses $value to create a LinkData object.

param $fieldname: 'link', or any of: see, throws, exception, sends

=cut

sub _createLinkData {
    my ( $this, $inFieldName, $inValue ) = @_;

    # test url pattern
    my $pattern = $VisDoc::StringUtils::PATTERN_URL;
    if ( $inValue =~ m/$pattern/s ) {
        my $value = $1;
        return VisDoc::FieldData->new( $inFieldName, $value );
    } else {
		return VisDoc::LinkData::createLinkData($inFieldName, $inValue);
    }
}

=pod

_getFieldNameParts( $text ) -> ($firstLine, \@fieldNameParts)

Reads in a text with format:
	optional first line
	@firstField value
	@secondField value
	line that belongs to secondField
	@thirdField

Parses out the first line.
Creates an array of field strings with the format:
	[
	'firstField value',
	'secondField value
	line that belongs to secondField',
	'thirdField'
	]

=cut

sub _getFieldNameParts {
    my ( $this, $inText ) = @_;

    my @fieldNameParts = split( /^[[:space:]]*@|\n[[:space:]]*@/, $inText );

    return ( $inText, undef ) if !( scalar @fieldNameParts );

    my $firstLine = splice( @fieldNameParts, 0, 1 );

    return ( $firstLine, \@fieldNameParts );
}

=pod

_processFields ( \@fieldStrings, $fileData ) -> (\@fields, \@paramFields)

Reads an array of strings with format:
	fieldname value

Creates a FieldData object for each key/value pair.
Returns a list of FieldData objects.

=cut

sub _processFields {
    my ( $this, $inFieldStrings, $inFileData ) = @_;

    my $fields;         # array ref
    my $paramFields;    # array ref

# run in reverse so that the (in natural order) next $storeCustomField can be appended to the (in natural order) previous field value
    while ( my $lastItem = pop( @{$inFieldStrings} ) ) {

        my $isParam = 0;
        my ( $fieldName, $value ) = $lastItem =~ m/^(\w+)\s*(.*?)$/gs;

        VisDoc::StringUtils::trimSpaces($value);
        $value =~ s/^\s*:*\s*(.*)\s*$/$1/;    # strip whitespace inside value

        # handle param field: clean up value string
        if ( $value && $fieldName eq 'param' ) {
            ( $fieldName, $value ) = $value =~ m/^(\w+)[[:space:]\:]*(.*)$/gs;
            $isParam = 1;
        }

        # process field
        my $field;
        if ( $fieldName =~ m/^(see|throws|exception|sends)$/ ) {

            # process link data from value
            $field = $this->_createLinkData( $fieldName, $value );
        }
        else {
            $field = VisDoc::FieldData->new( $fieldName, $value );
        }

        # insert at beginning of array to make up for the reverse running order
        if ($isParam) {
            unshift( @{$paramFields}, $field );
        }
        else {
            unshift( @{$fields}, $field );
        }
    }
    return ( $fields, $paramFields );
}

1;
