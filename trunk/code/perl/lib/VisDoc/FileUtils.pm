package VisDoc::FileUtils;

use strict;
use File::stat;
use File::Find;
use File::Spec;
use Cwd 'getcwd';

=pod

getFiles( \@filesAndDirs, \%validExtensions ) -> \@filesList

Reads in an list of files and dirs.
Returns a list of all files within those files and dirs.

param \%validExtensions: optional
param \%ignorePaths: optional

=cut

sub getFiles {
	my ($inputFilesAndDirs, $validExtensions, $ignorePaths) = @_;
	
	return undef if !$inputFilesAndDirs || !(scalar @{$inputFilesAndDirs});	
    
    # remove files that do not exist
    my @fileList;
    foreach my $file (@{$inputFilesAndDirs}) {
    	next if !$file;
    	if ($ignorePaths) {
    		while ( ( my $ignorePath, my $unused ) = each %{$ignorePaths} ) {
		    	next if $file =~ m/$ignorePath/;
		    }
	    }
	    next if !(-e $file);
        push (@fileList, $file);
	}
    
    return undef if !scalar @fileList;
    
    my $files;
   	my $wanted = sub {
		my ($volume, $directories, $file) = File::Spec->splitpath( $File::Find::name );
		return if !$file;
		return if $file =~ /^\..*?$/;
		return if !($file =~ /\./);
		if (defined $validExtensions) {
			my @parts = split(/\./, $file);
			my $extension = pop @parts;
			return if !($validExtensions->{$extension});
		}
		if ($ignorePaths) {
			my %ignore = %{$ignorePaths};
    		while ( ( my $ignorePath, my $unused ) = each %ignore ) {
		    	if ($directories =~ m/$ignorePath/) {
		    		return;
		    	}
		    	if ($file =~ m/$ignorePath/) {
		    		return;
		    	}
		    }
	    }
		push @{$files}, $File::Find::name;
   	};
    find(\&$wanted, @fileList);
	
	my $base = getcwd();
	foreach my $file (@{$files}) {
        $file = File::Spec->rel2abs($file, $base);
	}
	
	return $files;
}

1;
