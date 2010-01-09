package VisDoc::Logger;

use strict;

our $writeDir;
our $logText = '';

sub clear {
    $logText = '';
}

sub logParsedFile {
	my ($file) = @_;
	
	my ($volume, $directories, $name) = File::Spec->splitpath( $file );
	
	$logText .= "PARSED#$name#$file\n";
}

sub logTime {
	my ($startTime, $endTime) = @_;
		
	my $seconds = $endTime - $startTime;
	
	$logText .= "TIME#seconds=$seconds\n";
}

sub getLogText {
	return $logText;
}

1;
