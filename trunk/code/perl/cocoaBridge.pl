#! /usr/bin/perl -w

use strict;

#use warnings;
use Cwd 'getcwd';
use Getopt::Long;
use Pod::Usage;

BEGIN {
    my $root = Cwd::abs_path;
    unshift @INC, "$root/lib/CPAN/lib";
    unshift @INC, "$root/lib";
}

# parse command line options
Getopt::Long::Configure( "no_auto_abbrev", "no_ignore_case" );
my $dataPath        = '';
my $extensions      = '';
my $defaults        = '';
my $files           = '';
my $ignorePathNames = '';
&GetOptions(
    'datapath=s'   => \$dataPath,
    'extensions=s' => \$extensions,
    'files=s'      => \$files,
    'ignorepath:s' => \$ignorePathNames,
);

my $validExtensions;
if ($extensions) {
    map { $validExtensions->{$_} = 1; } split( /\s*,\s*/, $extensions );
}

$ignorePathNames ||= '.svn';
my $ignorePaths;
if ($ignorePathNames) {
    map { $ignorePaths->{$_} = 1; } split( /\s*,\s*/, $ignorePathNames );
}

my $doValidate = 1;

if ($files) {

    # check if we can read the right modules
    eval "use VisDoc";
    if ($@) {
        print STDOUT $@;
        die;
    }
    eval "use VisDoc::FileUtils";
    if ($@) {
        print STDOUT $@;
        die;
    }
    eval "use VisDoc::CocoaUtils";
    if ($@) {
        print STDOUT $@;
        die;
    }

    my $out      = '';
    my $pathInfo = '';

    my $argFiles = $files;

    # remove escaped spaces
    $argFiles =~ s/\\ / /go;
    my @inputFileList = split( /\s*,\s*/, $argFiles );

    my $fileInfo    = {};
    my $listedFiles = {};
    my $listedDirs  = {};
    foreach my $path (@inputFileList) {

        # make sure path does not have a trailing slash
        $path =~ s/^(.*?)\/*$/$1/;

        if ( -f $path ) {
            if ($doValidate) {
                my $fileInfo = VisDoc::validateFile($path);
                $listedFiles->{$path} = $fileInfo->{valid};
            }
            else {
                $listedFiles->{$path} = 1;
            }
        }
        if ( -d $path ) {
            my @tmpList = ($path);
            my $files =
              VisDoc::FileUtils::getFiles( \@tmpList, $validExtensions,
                $ignorePaths );

            if ($doValidate) {
                my $validCount = 0;
                foreach my $file ( @{$files} ) {
                    my $fileInfo = VisDoc::validateFile($file);
                    $validCount++ if $fileInfo->{valid};
                }
                $listedDirs->{$path} = $validCount;
            }
            else {
                $listedDirs->{$path} = scalar @{$files};
            }
        }

    }

    $out = "paths={\n$pathInfo};\n";

    # remove zero counts
    my $inValidListedFiles = {};
    my $inValidListedDirs  = {};

    while ( ( my $path, my $value ) = each %{$listedFiles} ) {
        if ( $value == 0 ) {
            $inValidListedFiles->{$path} = 0;
            delete $listedFiles->{$path};
        }
    }
    while ( ( my $path, my $value ) = each %{$listedDirs} ) {
        if ( $value == 0 ) {
            $inValidListedDirs->{$path} = 0;
            delete $listedDirs->{$path};
        }
    }
    if ( scalar keys %{$inValidListedFiles} ) {
        my $invalidListedFilesString =
          VisDoc::CocoaUtils::createPropertyListFromData($inValidListedFiles);
        $out .= "invalidListedFiles=$invalidListedFilesString;\n";
    }
    if ( scalar keys %{$inValidListedDirs} ) {
        my $invalidListedDirsString =
          VisDoc::CocoaUtils::createPropertyListFromData($inValidListedDirs);
        $out .= "invalidListedDirs=$invalidListedDirsString;\n";
    }

    if ( scalar keys %{$listedFiles} ) {
        my $validListedFilesString =
          VisDoc::CocoaUtils::createPropertyListFromData($listedFiles);
        $out .= "validListedFiles=$validListedFilesString;\n";
    }
    if ( scalar keys %{$listedDirs} ) {
        my $validListedDirsString =
          VisDoc::CocoaUtils::createPropertyListFromData($listedDirs);
        $out .= "validListedDirs=$validListedDirsString;\n";
    }
    my $validFileCount = scalar keys %{$listedFiles};
    my $validDirCount  = scalar keys %{$listedDirs};
    $out .=
"counts={\nvalidFileCount = $validFileCount;\nvalidDirCount = $validDirCount;\n};\n";

    VisDoc::CocoaUtils::writeStringToFile( $dataPath, $out );
    exit;
}

=pod
perl cocoaBridge.pl --files /Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/delegate,/Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/RegularPolygon.as,/Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/ReferencedClass.as


perl cocoaBridge.pl --files /Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/RegularPolygon.as,/Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/ReferencedClass.as

perl cocoaBridge.pl --files /Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management

perl cocoaBridge.pl --files '/Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/invaliddir/,/Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/IClock.as' --extensions 'as,java'


perl cocoaBridge.pl --files /Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management

perl cocoaBridge.pl --files /Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/lang/


perl cocoaBridge.pl --files /Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/lang,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/lang/IMultiLanguageTextContainer.as,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/lang/LanguageManager.as,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/lang/MultiLanguageTextContainer.as,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/lang/TextItemData.as,/Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management/movie --extensions as,java --ignorepath .svn

perl cocoaBridge.pl --files /Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/RegularPolygon.as,/Users/arthur/Documents/Perl/VisDoc_perl/VisDoc_tests/code/invaliddir/

perl cocoaBridge.pl --files /Data/Arthur_projecten/asapframework/asaplibrary/trunk/lib/org/asaplibrary/management

perl cocoaBridge.pl --files /Applications/Adobe\ Flash\ CS3/First\ Run/Classes/mx

=cut

1;

__DATA__
head1 NAME



=head1 SYNOPSIS



Options:

    -h  --help              Display this help
    -H  --man               Display detailed help (examples)
    --extensions			Comma-separated list of extensions of files that
    						should be processed (other files will be ignored)
	--files					Comma-separated list of filepaths to process
	--datapath				Filepath to write data to
	--defaults				Return the default values
	
=head1 EXAMPLES

=head2 First Example...
