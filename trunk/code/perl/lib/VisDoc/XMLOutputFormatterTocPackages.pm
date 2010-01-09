# See bottom of file for license and copyright information
#
# old VisDoc: overview frame

package VisDoc::XMLOutputFormatterTocPackages;
use base 'VisDoc::XMLOutputFormatterToc';

use strict;
use warnings;
use XML::Writer;

=pod

=cut

sub _uri {
    my ($this) = @_;

    return 'overview-frame';
}

sub _title {
    my ($this) = @_;

    return VisDoc::Language::getDocTerm( 'toc_packages_title',
        $this->{language} );
}

=pod

=cut

sub _writeTargetMarker {
    my ( $this, $inWriter ) = @_;

    $inWriter->cdataElement( 'tocMarkerOverviewFrame', 'true' );

}

=pod

_writeListData ($xmlWriter, $classData) -> $bool

=cut

sub _writeListData {
    my ( $this, $inWriter ) = @_;

    $inWriter->startTag('tocList');
    $inWriter->startTag('listGroup');

    my $packages;
    foreach my $fileData ( @{ $this->{data} } ) {
        foreach my $package ( @{ $fileData->{packages} } ) {
            push @$packages, $package;
        }
    }

    # sort packages
    @{$packages} =
      sort { lc( $a->{name} ) cmp lc( $b->{name} ) } @{$packages};

    my $path = '';
    foreach my $package ( @{$packages} ) {
        next if $package->isExcluded();
        next if !$this->{preferences}->{listPrivate} && !$package->isPublic();

        $inWriter->startTag('item');
        my $name   = $package->{name};
        my $uri    = $package->getUri();
        my $tocUri = "toc-package-$uri";
        $this->_writeLinkXml( $inWriter, $name, $tocUri );
        $inWriter->endTag('item');
    }

    $inWriter->endTag('listGroup');
    $inWriter->endTag('tocList');

    return 1;
}

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
