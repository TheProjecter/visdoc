package VisDoc::XMLOutputFormatterAllConstantsFrame;
use base 'VisDoc::XMLOutputFormatterAllPropertiesFrame';

use strict;
use XML::Writer;

our $URI = 'allconstants-frame';

=pod

=cut

sub _uri {
    my ($this) = @_;

    return $URI;
}

sub _title {
    my ($this) = @_;

    return $this->_docTerm('all_constants_title');
}

sub _ignore {
    my ($this, $inAttribute) = @_;
	
	return 0 if ($inAttribute && ($inAttribute & $VisDoc::MemberData::TYPE->{CONST}) );
	return 1;
}

1;

