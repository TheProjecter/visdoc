package VisDoc::MemberFormatterBase;

use strict;

=pod

=cut

sub new {
    my ($class) = @_;
    my $this = {};

    $this->{PATTERN_PARAMETER_STRING}          = '';
    $this->{PATTERN_MEMBER_TYPE_INFO_PROPERTY} = '';
    $this->{PATTERN_MEMBER_TYPE_INFO_METHOD}   = '';
	$this->{PATTERN_MEMBER_PROPERTY_LEFT}      = '';
	$this->{PATTERN_MEMBER_METHOD_LEFT}        = '';
	$this->{PATTERN_MEMBER_METHOD_RIGHT}       = '';
	
    bless $this, $class;
    return $this;
}

=pod

typeInfo( $member ) -> $text

=cut

sub typeInfo {
    my ( $this, $inMember ) = @_;

    my $outText = '';

    if ( $inMember->isa("VisDoc::PropertyData") ) {

        my @elems = split( /\|/, $this->{PATTERN_MEMBER_TYPE_INFO_PROPERTY} );

        foreach my $elem (@elems) {     
            $outText .= $this->getVarArgsString($elem, $inMember);
            $outText .= $this->getNameString($elem, $inMember);
            $outText .= $this->getDataTypeString($elem, $inMember);
            $outText .= $this->getValueString($elem, $inMember);
        }
    }
    elsif ( $inMember->isa("VisDoc::MethodData") ) {
        my @elems = split( /\|/, $this->{PATTERN_MEMBER_TYPE_INFO_METHOD} );
        foreach my $elem (@elems) {
        	$outText .= $this->getNameString($elem, $inMember);
        	$outText .= $this->getParametersString($elem, $inMember);
        	$outText .= $this->getReturnTypeString($elem, $inMember);
        }
    }
	$outText =~ s/  / /go;
    return $outText;
}

=pod

formatString( $format, $member ) -> $text

=cut

sub formatString {
    my ( $this, $inFormat, $inMember ) = @_;

    my $outText = $inFormat;

    my $parameterListString = '';
    if ( $inMember->{parameters} ) {
        $parameterListString =
          $this->parameterListToString( $inMember->{parameters} );
    }
    $outText =~ s/%p%/$parameterListString/g;

    my $returnType = '';
    if ( $inMember->{returnType} ) {
        $returnType = $inMember->{returnType};
    }
    $outText =~ s/%t%/$returnType/g;

    $outText =~ s/  / /go;

    return $outText;
}

=pod

parameterListToString( \@parameters ) -> $text

Converts a list of parameters to a string.

=cut

sub parameterListToString {
    my ( $this, $inParameters ) = @_;

	return '' if !$inParameters;
	
    my $parameterString =
      join( ', ', map { $this->formatParameterData($_) } @{$inParameters} );

    return $parameterString;
}

=pod

formatParameterData( $parameterData ) -> $text

=cut

sub formatParameterData {
    my ( $this, $inParameterData ) = @_;

    my $outText = '';

    my @elems = split( /\|/, $this->{PATTERN_PARAMETER_STRING} );
    foreach my $elem (@elems) {
        $outText .= $this->getVarArgsString($elem, $inParameterData);
        $outText .= $this->getNameString($elem, $inParameterData);
        $outText .= $this->getPropertyTypeString($elem, $inParameterData);
        $outText .= $this->getDataTypeString($elem, $inParameterData);
        $outText .= $this->getValueString($elem, $inParameterData);
    }
    $outText =~ s/  / /go;
    return $outText;
}

=pod

getDataString($element, $member, $dataKey, $stringKey, $tag) -> $text

=cut

sub getDataString {
    my ( $this, $inElement, $inValue, $inStubStringKey, $inTag ) = @_;

	my $outText = '';

	if ( ( $inElement =~ m/\b$inStubStringKey\b/ ) && $inValue ) {
		my $data = $inValue;
		$data = "<$inTag>$data</$inTag>" if $inTag;
		$inElement =~ s/\b$inStubStringKey\b/$data/;
		$outText .= $inElement;
	}
	return $outText;
}

=pod

=cut

sub getAccessString {
    my ( $this, $inElement, $inMember ) = @_;

	my $value = join(" ", @{$inMember->{access}});
	return $this->getDataString($inElement, $value, 'ACCESS', undef);
}

=pod

=cut

sub getNameString {
    my ( $this, $inElement, $inMember, $inTag ) = @_;

	return $this->getDataString($inElement, $inMember->{name}, 'NAME', $inTag);
}

=pod

To be implemented by subclasses

=cut

sub getPropertyTypeString {
    my ( $this, $inElement, $inMember ) = @_;

	return '';
}

=pod

=cut

sub getDataTypeString {
    my ( $this, $inElement, $inMember ) = @_;

	return $this->getDataString($inElement, $inMember->{dataType}, 'DATATYPE');
}

=pod

=cut

sub getValueString {
    my ( $this, $inElement, $inMember ) = @_;

	return $this->getDataString($inElement, $inMember->{value}, 'VALUE');
}

=pod

=cut

sub getVarArgsString {
    my ( $this, $inElement, $inMember ) = @_;

	return $this->getDataString($inElement, $inMember->{varArgs}, 'VARARGS');
}

=pod

=cut

sub getReturnTypeString {
    my ( $this, $inElement, $inMember ) = @_;

	return $this->getDataString($inElement, $inMember->{returnType}, 'RETURNTYPE');
}

=pod

=cut

sub getParametersString {
    my ( $this, $inElement, $inMember ) = @_;

	my $outText = '';
	if ( $inElement =~ m/\bPARAMETERS\b/ ) {
		my $value = $this->parameterListToString($inMember->{parameters}) || '';
		$inElement =~ s/\bPARAMETERS\b/$value/;
		$outText .= $inElement;
	}
    return $outText;   
}

=pod

fullMemberStringLeft( $memberData ) -> $text

=cut

sub fullMemberStringLeft {
    my ( $this, $inMember ) = @_;

	my $outText = '';

    if ( $inMember->isa("VisDoc::PropertyData") ) {

        my @elems = split( /\|/, $this->{PATTERN_MEMBER_PROPERTY_LEFT} );
        foreach my $elem (@elems) {
        	$outText .= $this->getAccessString($elem, $inMember);
        	$outText .= $this->getNameString($elem, $inMember, 'strong');
        	$outText .= $this->getPropertyTypeString($elem, $inMember);
        	$outText .= $this->getDataTypeString($elem, $inMember);
        	$outText .= $this->getValueString($elem, $inMember);
        }
    }
    elsif ( $inMember->isa("VisDoc::MethodData") ) {
    	my @elems = split( /\|/, $this->{PATTERN_MEMBER_METHOD_LEFT} );
        foreach my $elem (@elems) {
        	$outText .= $this->getAccessString($elem, $inMember);
        	$outText .= $this->getNameString($elem, $inMember, 'strong');
        	$outText .= $this->getMethodTypeString($elem, $inMember);
        	$outText .= $this->getDataTypeString($elem, $inMember);
        }
    }
    
	$outText =~ s/  / /go;
    return $outText;
}

=pod

fullMemberStringRight( $memberData ) -> $text

=cut

sub fullMemberStringRight {
    my ( $this, $inMember ) = @_;

	my $outText = '';

    if ( $inMember->isa("VisDoc::MethodData") ) {
    	my @elems = split( /\|/, $this->{PATTERN_MEMBER_METHOD_RIGHT} );
        foreach my $elem (@elems) {
        	my $parameterList = $this->getParametersString($elem, $inMember);
        	$parameterList =~ s/\s*,\s*/,\n /go;
        	$outText .= $parameterList;
        	$outText .= $this->getReturnTypeString($elem, $inMember);
        }
    }
    
	$outText =~ s/  / /go;
    return $outText;
}

=pod

=cut

sub getSetString {
    my ( $this, $inMember, $inReadText, $inWriteText ) = @_;

	my @getSetElems;
	my $type = $this->getDefaultReadWriteType($inMember);
		
	if ($type & $VisDoc::MemberData::TYPE->{READ}) {
		push @getSetElems, $inReadText;
	}
	if ($type & $VisDoc::MemberData::TYPE->{WRITE}) {
		push @getSetElems, $inWriteText;
	}
	my $getSetString = join ',', @getSetElems;
	
	return $getSetString;
}

=pod

=cut

sub getDefaultReadWriteType {
    my ( $this, $inMember ) = @_;

	return $inMember->{type} || ($VisDoc::MemberData::TYPE->{READ} | $VisDoc::MemberData::TYPE->{WRITE});
}

1;

