package VisDoc::MemberFormatterAS3;

use base 'VisDoc::MemberFormatterAS2';
use strict;

sub new {
    my ( $class, $inFileParser ) = @_;

    my VisDoc::MemberFormatterAS3 $this = $class->SUPER::new();

    bless $this, $class;
    return $this;
}

=pod

=cut

sub getPropertyTypeString {
    my ( $this, $inElement, $inMember ) = @_;

	my $outText = '';
	if ( $inElement =~ m/\bPROPERTYTYPE\b/ ) {
		my $type = 'var';
		if ($inMember->{type}) {
			$type = 'const' if ($inMember->{type} & $VisDoc::MemberData::TYPE->{CONST});
			$type = 'namespace' if ($inMember->{type} & $VisDoc::MemberData::TYPE->{NAMESPACE});
		}
		$inElement =~ s/\bPROPERTYTYPE\b/$type/;
		$outText .= $inElement;
	}
	return $outText;
}

1;
