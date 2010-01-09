package VisDoc::Event::Event;

use strict;

use overload ( '""' => \&as_string );

=pod

Creates a new event with the name of the event handler and the source of the event.
@param inName: name of event (and name of handler function when no Delegate is used)
@param inSource:Object, (optional) source of event

=cut

sub new {
    my ( $class, $inName, $inSource ) = @_;

    my $this = {
        name      => $inName,
        source    => $inSource,
    };
    bless $this, $class;
    return $this;
}

=pod

=cut

sub as_string {
    my ($this) = @_;

    my $str = 'Event:';
    $str .= "\n\t name=$this->{name}"   if defined $this->{name};
    $str .= "\n\t source=$this->{source}" if defined $this->{source};
    $str .= "\n";
    return $str;
}

1;
