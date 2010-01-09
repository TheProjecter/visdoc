package VisDoc::MemberFormatterJava;

use base 'VisDoc::MemberFormatterBase';
use strict;

sub new {
    my ( $class, $inFileParser ) = @_;

    my VisDoc::MemberFormatterJava $this = $class->SUPER::new();

    $this->{PATTERN_PARAMETER_STRING}          = 'DATATYPE| NAME';
    $this->{PATTERN_MEMBER_TYPE_INFO_PROPERTY} = 'DATATYPE| NAME';
    $this->{PATTERN_MEMBER_TYPE_INFO_METHOD}   = 'RETURNTYPE |NAME|(PARAMETERS)';
	$this->{PATTERN_MEMBER_PROPERTY_LEFT}      = '';

    bless $this, $class;
    return $this;
}

=pod

=cut

sub getPropertyTypeString {
    my ( $this, $inElement, $inMember ) = @_;

	my $outText = '';
	if ( $inElement =~ m/\bPROPERTYTYPE\b/ && $inMember->{type} ) {
		my $type = $inMember->{type};
		$inElement =~ s/\bPROPERTYTYPE\b/$type/;
		$outText .= $inElement;
	}
	return $outText;
}

=pod

=cut

sub getMethodTypeString {
    my ( $this, $inElement, $inMember ) = @_;

	my $outText = '';
	if ( $inElement =~ m/\bMETHODTYPE\b/ && $inMember->{type} ) {
		my $type = $inMember->{type};
		$inElement =~ s/\bMETHODTYPE\b/$type/;
		$outText .= $inElement;
	}
	return $outText;
}

1;
