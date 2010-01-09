package VisDoc::CocoaUtils;

use strict;

=pod

createPropertyListFromData( \%data, $key ) -> $propertyListString

param $key is optional

=cut

sub createPropertyListFromData {
	my ($inData, $inKey) = @_;
	
	my $key = $inKey ? "$inKey = " : '';
	my $itemSeparator = ' = ';
	my $keyValueSeparator = '; ';
	my @list = ();

	while ( my ($ikey, $ivalue) = each %{$inData}) {
		$ivalue = '' if !defined $ivalue;
		$ivalue =~ s/\"/\\"/go; # escape quotes
		push @list, "\"$ikey\"$itemSeparator\"$ivalue\";";
	}
	my $propertyList = "$key\{\n" . join("\n", @list) . "\n}";
	return $propertyList;
}

=pod

writeStringToFile( $path, $dataString )

=cut

sub writeStringToFile {
	my ($inWritePath, $inDataString) = @_;

	if ($inWritePath) {
		eval "use File::Slurp qw(write_file)";
		if ($@) {
			print STDOUT $@;
			die;
		}
		File::Slurp::write_file( $inWritePath, { atomic => 1 }, $inDataString );
	} else {    
		print STDOUT $inDataString;
	}
}

1;
