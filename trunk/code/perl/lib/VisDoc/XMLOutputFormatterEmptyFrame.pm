package VisDoc::XMLOutputFormatterEmptyFrame;
use base 'VisDoc::XMLOutputFormatterTocBase';

use strict;
use XML::Writer;

=pod

_formatData ($xmlWriter, $classData) -> $bool

=cut

sub _formatData {
    my ( $this, $inWriter ) = @_;

    $this->_writeTitleAndPageId($inWriter);
    $this->_writeCSSLocation($inWriter);
    $this->_writeTargetMarker($inWriter);
    
    return 1;
}

=pod

=cut

sub _uri {
    my ($this) = @_;

    return 'empty-frame';
}

sub _title {
    my ($this) = @_;

    return '';
}

1;

