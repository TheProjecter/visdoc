package VisDoc::HashUtils;

use strict;

my $PATTERN_KEY_IS_VALUE = '
  ^									# start of string
  (\w+)								# key at index 1
  \s*\=*\s*							# =	
  (.*?)								# value at index 2
  $									# end of string
  ';

=pod

mergeHashes (\%a, \%b ) -> \%merged

Merges 2 hash references.

=cut

sub mergeHashes {
    my ( $A, $B ) = @_;

    my %merged = ();
    while ( my ( $k, $v ) = each(%$A) ) {
        $merged{$k} = $v;
    }
    while ( my ( $k, $v ) = each(%$B) ) {
        $merged{$k} = $v;
    }
    return \%merged;
}

1;
