package VisDoc::MemberFormatterAS2;

use base 'VisDoc::MemberFormatterBase';
use strict;

sub new {
    my ( $class, $inFileParser ) = @_;

    my VisDoc::MemberFormatterAS2 $this = $class->SUPER::new();

    $this->{PATTERN_PARAMETER_STRING}          = 'VARARGS|NAME|:DATATYPE| = VALUE';
    $this->{PATTERN_MEMBER_TYPE_INFO_PROPERTY} = ' : DATATYPE';
    $this->{PATTERN_MEMBER_TYPE_INFO_METHOD}   = '(PARAMETERS)| : RETURNTYPE';
	$this->{PATTERN_MEMBER_PROPERTY_LEFT}   = 'ACCESS |PROPERTYTYPE |NAME|:DATATYPE| = VALUE';
	$this->{PATTERN_MEMBER_METHOD_LEFT}   = 'ACCESS |METHODTYPE |NAME ';
	$this->{PATTERN_MEMBER_METHOD_RIGHT}   = '(PARAMETERS)| : RETURNTYPE';
	
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
	if ( $inElement =~ m/\bMETHODTYPE\b/ ) {
		my $type = 'function';
		$inElement =~ s/\bMETHODTYPE\b/$type/;
		$outText .= $inElement;
	}
	return $outText;
}

1;
