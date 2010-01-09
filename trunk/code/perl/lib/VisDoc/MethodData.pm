package VisDoc::MethodData;

use base qw(VisDoc::MemberData VisDoc::Event::Listener);
use strict;

=pod

=cut

sub new {
    my ($class) = @_;
    my VisDoc::MethodData $this = $class->SUPER::new();

    $this->{parameters}    = undef;    # ref of list of parameters
    $this->{returnType}    = undef;    # return type (String)
    $this->{exceptionType} = undef;    # exception type (String)

	$this->addEventListener($VisDoc::FindLinksEvent::NAME, \&onFindLinks, $this);

    bless $this, $class;
    return $this;
}

=pod

StaticMethod typeString($typeNum) -> $typeString

=cut

sub typeString {
    my ($inType) = @_;

    my @type;
    push( @type, 'READ' )  if ( $inType & $VisDoc::MemberData::TYPE->{READ} );
    push( @type, 'WRITE' ) if ( $inType & $VisDoc::MemberData::TYPE->{WRITE} );

    return join( ";", @type );
}

=pod

See MemberData::onFindLinks

=cut

sub onFindLinks {
	my ($this, $inEvent) = @_;
	
	my @linkFields = qw(returnType exceptionType);
	&VisDoc::MemberData::onFindLinks($this, $inEvent, \@linkFields);
}

1;
