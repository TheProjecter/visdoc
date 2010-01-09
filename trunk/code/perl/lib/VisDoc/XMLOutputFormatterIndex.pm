package VisDoc::XMLOutputFormatterIndex;
use base 'VisDoc::XMLOutputFormatterBase';

use strict;
use XML::Writer;

=pod

=cut

sub new {
    my ( $class, $inPreferences, $inUri ) = @_;

    my VisDoc::XMLOutputFormatterIndex $this = $class->SUPER::new($inPreferences, undef, undef);
	
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

	$inWriter->cdataElement('title', $this->{preferences}->{indexTitle});
}

=pod

<frameSizes>
	25%,*
</frameSizes>

=cut

sub _writeFrameSizes {
    my ( $this, $inWriter ) = @_;

	$inWriter->cdataElement('frameSizes', "$this->{preferences}->{sidebarWidth},*");
}

=pod

=cut

sub _uri {
    my ($this) = @_;

    return $this->{uri};
}


1;
