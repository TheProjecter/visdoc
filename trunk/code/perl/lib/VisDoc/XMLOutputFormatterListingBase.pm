package VisDoc::XMLOutputFormatterListingBase;
use base 'VisDoc::XMLOutputFormatterBase';

use strict;
use XML::Writer;

=pod

=cut

sub new {
    my ( $class, $inPreferences, $inData ) = @_;

    my VisDoc::XMLOutputFormatterListingBase $this = $class->SUPER::new($inPreferences, undef, $inData);

    bless $this, $class;
    return $this;
}

=pod

_formatData ($xmlWriter) -> $bool

=cut

sub _formatData {
    my ( $this, $inWriter ) = @_;

    $this->_writeCSSLocation($inWriter);
    $this->_writeTitleAndPageId($inWriter);
    my $hasFormattedData = $this->_writeList($inWriter);
    $this->_writeFooter($inWriter);
    return $hasFormattedData;
}

=pod

_writeList( $xmlWriter ) -> $bool

to be implemented by subclasses

=cut

sub _writeList {
    my ( $this, $inWriter ) = @_;
    
    return 0;
}

=pod

_documentType() -> $text

Type of this document

=cut

sub _documentType {
    my ($this) = @_;

    return 'listing';
}

1;

