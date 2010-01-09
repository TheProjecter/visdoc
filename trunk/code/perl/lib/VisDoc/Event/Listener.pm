package VisDoc::Event::Listener;

use strict;

our $eventListeners;

sub new {
    my ( $class, $inFileParser ) = @_;
    my $this = {};

    bless $this, $class;
    return $this;
}

sub addEventListener {
    my ($this, $inEventName, $inHandler, $inOwner) = @_;
	
	if (!$eventListeners->{$inEventName}) {
		$eventListeners->{$inEventName} = ();
	}
    push(@{$eventListeners->{$inEventName}}, {handler => $inHandler, owner => $inOwner} );
}

sub removeEventListener {
    my ($this, $inEventName, $inHandler) = @_;
    
    die ("removeEventListener not implemented!");
}

1;
