package VisDoc::MetadataData;

use strict;

our $NO_KEY = 'NO_KEY';

=pod

=cut

sub new {
    my ( $class, $inName, $inItems ) = @_;
    my $this = {};
    $this = {
        name  => $inName,     # name string
        items => $inItems,    # ref of list of hashes
    };
    bless $this, $class;
    return $this;
}

1;
