package VisDoc::FindLinksEvent;

use strict;
use base 'VisDoc::Event::Event';

our $NAME = 'FindLinksEvent';

=pod

param classes: list of references to all ClassData objects

=cut

sub new {
    my ( $class, $inName, $inSource, $inClasses, $inCallBack ) = @_;

	my VisDoc::FindLinksEvent $this = $class->SUPER::new($inName, $inSource);
    $this->{classes} = $inClasses;
    $this->{callback} = $inCallBack;

    bless $this, $class;
    return $this;
}

1;
