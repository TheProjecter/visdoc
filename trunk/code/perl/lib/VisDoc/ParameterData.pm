package VisDoc::ParameterData;

use base 'VisDoc::Event::Listener';
use strict;

use VisDoc::FindLinksEvent;

=pod

=cut

sub new {
    my ( $class, $inVarArgs, $inName, $inDataType, $inDefaultValue ) = @_;
    
    my VisDoc::ParameterData $this = $class->SUPER::new();

    $this->{varArgs}      = $inVarArgs;
    $this->{name}         = $inName;
    $this->{dataType}     = $inDataType;
    $this->{value}        = $inDefaultValue;
    
   	$this->addEventListener($VisDoc::FindLinksEvent::NAME, \&onFindLinks, $this);

    bless $this, $class;
    return $this;
}

=pod

Event handler called by FileData.
Go through strings to find any references to classes, replace them with link stubs.

=cut

sub onFindLinks {
	my ($this, $inEvent) = @_;
	
	my @linkFields = qw(dataType value);
	&VisDoc::MemberData::onFindLinks($this, $inEvent, \@linkFields);
}

1;
