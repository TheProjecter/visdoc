# See bottom of file for license and copyright information

package VisDoc::XMLOutputFormatterTocBase;
use base 'VisDoc::XMLOutputFormatterBase';

use strict;
use warnings;
use XML::Writer;

=pod

=cut

sub new {
    my ( $class, $inPreferences, $inLanguage, $inData, $inTocNavigationKeys ) =
      @_;

    my VisDoc::XMLOutputFormatterTocBase $this =
      $class->SUPER::new( $inPreferences, $inLanguage, $inData );

    $this->{tocNavigationKeys} = $inTocNavigationKeys;
    bless $this, $class;
    return $this;
}

=pod

_formatData ($xmlWriter, $classData) -> $bool

=cut

sub _formatData {
    my ( $this, $inWriter ) = @_;

    $this->_writeTitleAndPageId($inWriter);
    $this->_writeCSSLocation($inWriter);
    $this->_writeTargetMarker($inWriter);
    $this->_writeTocNavigation($inWriter);
    my $hasFormattedData = $this->_writeListData($inWriter);

    return $hasFormattedData;
}

=pod

_writeListData ($xmlWriter) -> $bool

=cut

sub _writeListData {
    my ( $this, $inWriter ) = @_;

    $inWriter->startTag('tocList');
    $inWriter->startTag('listGroup');

    my $classes;
    my $languages
      ; # store the language of each class to pass with the class attributes later on
    foreach my $fileData ( @{ $this->{data} } ) {
        foreach my $package ( @{ $fileData->{packages} } ) {
            foreach my $class ( @{ $package->{classes} } ) {
                push @$classes, $class;
                $languages->{ $class->{classpath} } = $fileData->{language};
            }
        }
    }

    # sort classes
    @{$classes} =
      sort {
        lc( $a->getClasspathWithoutName() ) cmp
          lc( $b->getClasspathWithoutName() )
      } @{$classes};

    my $path = '';
    foreach my $class ( @{$classes} ) {
        next if $class->isExcluded();
        next if !$this->{preferences}->{listPrivate} && !$class->isPublic();

        my $classpath = $class->getClasspathWithoutName();
        if ( $path ne $classpath ) {
            $inWriter->startTag('item');
            $this->_writeLinkXml( $inWriter, $classpath, '' );
            $path = $classpath;
            $inWriter->endTag('item');
        }
        my $attributes = {
            path     => $path,
            isPublic => $class->isPublic(),
            isClass  => ( $class->{type} & $VisDoc::ClassData::TYPE->{CLASS} ),
            isInterface =>
              ( $class->{type} & $VisDoc::ClassData::TYPE->{INTERFACE} ),
            language => $languages->{ $class->{classpath} },
            access   => $class->{access},
        };
        $this->_writeClassItem( $inWriter, $class->{name}, $class->getUri(),
            $attributes );
    }

    $inWriter->endTag('listGroup');
    $inWriter->endTag('tocList');

    return 1;
}

=pod

=cut

sub _writeTargetMarker {
    my ( $this, $inWriter ) = @_;

    $inWriter->cdataElement( 'tocMarker', 'true' );

}

=pod

<items>
	<item>
		<link>
			<name>
				<![CDATA[Main]]>
			</name>
			<uri>
				<![CDATA[main]]>
			</uri>
		</link>
	</item>
</items>

=cut

sub _writeTocNavigation {
    my ( $this, $inWriter ) = @_;

    return if !$this->{tocNavigationKeys};

    $inWriter->startTag('tocNavigation');

    my $callToWriteLink = sub {
        my ( $inTitleKey, $inUri ) = @_;

        $inWriter->startTag('item');
        $this->_writeLinkXml( $inWriter, $this->_docTerm($inTitleKey), $inUri );
        $inWriter->endTag('item');
    };

    my $callToWriteName = sub {
        my ($inTitleKey) = @_;

        $inWriter->startTag('item');
        $inWriter->cdataElement( 'name', $this->_docTerm($inTitleKey) );
        $inWriter->endTag('item');
    };

    my $keys = $this->{tocNavigationKeys};

    if ( $keys->{'main'} ) {
        &$callToWriteLink( 'main_link', 'main' );
    }
    else {
        &$callToWriteName('main_link');
    }

    if ( $keys->{'overview-tree'} ) {
        &$callToWriteLink( 'tree_link',
            $VisDoc::XMLOutputFormatterOverviewTree::URI );
    }
    else {
        &$callToWriteName('tree_link');
    }

    if ( $keys->{'classes'} ) {
        &$callToWriteLink( 'all_classes_link',
            $VisDoc::XMLOutputFormatterAllClassesFrame::URI );
    }
    else {
        &$callToWriteName('all_classes_link');
    }

    if ( $keys->{'methods'} ) {
        &$callToWriteLink( 'all_methods_link',
            $VisDoc::XMLOutputFormatterAllMethodsFrame::URI );
    }
    else {
        &$callToWriteName('all_methods_link');
    }

    if ( $keys->{'constants'} ) {
        &$callToWriteLink( 'all_constants_link',
            $VisDoc::XMLOutputFormatterAllConstantsFrame::URI );
    }
    else {
        &$callToWriteName('all_constants_link');
    }

    if ( $keys->{'properties'} ) {
        &$callToWriteLink( 'all_properties_link',
            $VisDoc::XMLOutputFormatterAllPropertiesFrame::URI );
    }
    else {
        &$callToWriteName('all_properties_link');
    }

    if ( $keys->{'deprecated'} ) {
        &$callToWriteLink( 'all_deprecated_link',
            $VisDoc::XMLOutputFormatterAllDeprecatedFrame::URI );
    }
    else {
        &$callToWriteName('all_deprecated_link');
    }

    $inWriter->endTag('tocNavigation');
}

=pod

=cut

sub _documentType {
    my ($this) = @_;

    return 'tableofcontents';
}

=pod

=cut

sub _uri {
    my ($this) = @_;

    return 'PageTOC';
}

=pod

=cut

sub _title {
    my ($this) = @_;

    my $title = $this->{preferences}->{indexTitle} || '';
    return $title;
}

=pod
- (NSString*)formatElement:(ASClassData*)inClassData
					  name:(NSString*)inName
					   URI:(NSString*)inURI
					  path:(NSString*)inPath
{
	NSString* link = [self formatLink:inName URI:inURI];
	NSString* attribute = [self attributeXML:inClassData];
	NSString* path = @"";
	if ([inPath isValidString]) {
		path = [NSString stringWithFormat:@"<packagePath>%@</packagePath>", inPath];
	}
	NSString* attributeTags = [NSString stringWithFormat:@"%@%@", attribute, path];
	return [self wrapLinkInItemTag:link attributeTags:attributeTags];
}
=cut

1;

# VisDoc - Code documentation generator, http://visdoc.org
# This software is licensed under the MIT License
#
# The MIT License
#
# Copyright (c) 2010 Arthur Clemens, VisDoc contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
