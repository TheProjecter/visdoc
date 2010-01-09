# See bottom of file for license and copyright information

package VisDoc::XMLOutputFormatterIndex;
use base 'VisDoc::XMLOutputFormatterBase';

use strict;
use warnings;
use XML::Writer;

=pod

=cut

sub new {
    my ( $class, $inPreferences, $inUri ) = @_;

    my VisDoc::XMLOutputFormatterIndex $this =
      $class->SUPER::new( $inPreferences, undef, undef );

    $this->{uri} = $inUri;
    bless $this, $class;
    return $this;
}

=pod

_formatData ($xmlWriter, $classData) -> $bool

=cut

sub _formatData {
    my ( $this, $inWriter ) = @_;

    $inWriter->startTag('index');
    $this->_writeTitleAndPageId($inWriter);
    $this->_writeFrameSizes($inWriter);
    $inWriter->endTag('index');

    return 1;
}

=pod

<title>
	<![CDATA[AlarmClock]]>
</title>

=cut

sub _writeTitleAndPageId {
    my ( $this, $inWriter ) = @_;

    $inWriter->cdataElement( 'title', $this->{preferences}->{indexTitle} );
}

=pod

<frameSizes>
	25%,*
</frameSizes>

=cut

sub _writeFrameSizes {
    my ( $this, $inWriter ) = @_;

    $inWriter->cdataElement( 'frameSizes',
        "$this->{preferences}->{sidebarWidth},*" );
}

=pod

=cut

sub _uri {
    my ($this) = @_;

    return $this->{uri};
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
