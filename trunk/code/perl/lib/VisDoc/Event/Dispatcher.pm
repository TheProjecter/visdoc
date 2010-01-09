package VisDoc::Event::Dispatcher;

use strict;
use VisDoc::Event::Listener;

sub dispatchEvent {
    my ($this, $inEventObject) = @_;
	
	# get all listeners
	my $listeners = $VisDoc::Event::Listener::eventListeners->{ $inEventObject->{name} };
	foreach my $listener (@{$listeners}) {
		my $handler = $listener->{handler};
		my $owner = $listener->{owner};
		$owner->$handler($inEventObject);
	}
}

1;
