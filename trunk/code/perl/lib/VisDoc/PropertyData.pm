package VisDoc::PropertyData;

use strict;
use base qw(VisDoc::MemberData VisDoc::Event::Listener);

use VisDoc::FindLinksEvent;

=pod

=cut

sub new {
    my ($class) = @_;
    my VisDoc::PropertyData $this = $class->SUPER::new();

    $this->{dataType} = undef;   # data type (for properties: int, String, etc.)
    $this->{value}    = undef;   # string

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
    push( @type, 'CONST' ) if ( $inType & $VisDoc::MemberData::TYPE->{CONST} );
    push( @type, 'NAMESPACE' )
      if ( $inType & $VisDoc::MemberData::TYPE->{NAMESPACE} );

    return join( ";", @type );
}

=pod

See MemberData::onFindLinks

=cut

sub onFindLinks {
	my ($this, $inEvent) = @_;
	
	my @linkFields = qw(dataType value);
	&VisDoc::MemberData::onFindLinks($this, $inEvent, \@linkFields);
}

1;
