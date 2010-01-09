package VisDoc::XMLOutputFormatterMainPage;
use base 'VisDoc::XMLOutputFormatterListingBase';

use strict;
use XML::Writer;

=pod

=cut

sub _uri {
    my ($this) = @_;

    return 'main';
}

sub _title {
    my ($this) = @_;

    return $this->{preferences}->{indexTitle} || 'main';
}

=pod

_formatData ($xmlWriter) -> $bool

=cut

sub _formatData {
    my ( $this, $inWriter ) = @_;

    $this->_writeCSSLocation($inWriter);
    $this->_writeTitleAndPageId($inWriter);
    
    return 1;
}

1;

