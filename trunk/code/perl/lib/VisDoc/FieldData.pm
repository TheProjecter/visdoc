package VisDoc::FieldData;

use strict;

use overload ( '""' => \&as_string );

=pod

Used for:
	fields:			@return, @since, @see, {@link ...}, {@linkplain ...}
	param fields:	@param name : description

=cut

=pod

=cut

sub new {
    my ( $class, $inName, $inValue ) = @_;
    my $this = {
        name  => $inName,
        value => $inValue || '',    # value string
             #inheritedComment => undef,   # NEEDED? inherited comment
             #overridden        => 0,       # NEEDED?
    };
    bless $this, $class;
    return $this;
}

=pod

=cut

sub getValue {
    my ($this) = @_;

    return $this->{value};
}

=pod

=cut

sub as_string {
    my ($this) = @_;

    my $str = 'FieldData:';
    $str .= "\n\t name=$this->{name}"   if defined $this->{name};
    $str .= "\n\t value=$this->{value}" if defined $this->{value};
    $str .= "\n";
    return $str;
}

1;
