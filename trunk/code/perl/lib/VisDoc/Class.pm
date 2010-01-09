package VisDoc::Class;

use strict;
use VisDoc::ClassData;

use overload ( '""' => \&as_string );

=pod

=cut

sub new {
    my ( $class, $inName ) = @_;

    my $name      = undef;
    my $classpath = undef;
    if ( $inName =~ m/(.*)\.(.*?)$/ ) {
        $name      = $2;
        $classpath = $inName;
    }
    else {
        $name = $inName;
    }
    my $this = {
        name      => $name      || undef,    # class or interface name
        classpath => $classpath || undef,    # package name plus class name
        classdata => undef,                  # ref to ClassData object
    };
    bless $this, $class;
    return $this;
}

sub as_string {
    my ($this) = @_;

    my $str = 'Class:';
    $str .= "\n\t name=$this->{name}"           if defined $this->{name};
    $str .= "\n\t classpath=$this->{classpath}" if defined $this->{classpath};
    $str .= "\n\t classdata=$this->{classdata}" if defined $this->{classdata};
    $str .= "\n";
    return $str;
}

1;
