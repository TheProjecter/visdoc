#! /usr/bin/perl -w

use strict;
use warnings;
use File::Spec;
use Getopt::Long;
use Pod::Usage;
use Cwd 'getcwd';

BEGIN {
    my $here = Cwd::abs_path;
    my $root = $here;
    unshift @INC, "$root/lib/CPAN/lib";
    unshift @INC, "$root/lib";
}

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
eval "use VisDoc::Defaults";
if ($@) {
    print STDOUT $@;
    die;
}

# parse command line options
Getopt::Long::Configure( "bundling", "no_auto_abbrev", "no_ignore_case" );

my $startTime   = time();
my $out         = '';
my $process     = '';
my $preferences = $VisDoc::Defaults::SETTINGS;
my $unused =
  $VisDoc::Defaults::SETTINGS;    # to remove the 'used only once' warning

$preferences->{'out'}     = \$out;
$preferences->{'process'} = \$process;

&GetOptions(
    $preferences,                       'out=s',
    'process=s',                        
    'copyCSS:i',                        'copyright:i',
    'copyrightText:s',                  'extensions:s',
    'eventHandlerPrefixes:s',           'eventHandlers:i',
    'generateIndex:i',                  'ignoreClasses:i',
    'includeSourceCode:i',              'indexTitle:s',
    'listPrivate:i',                    'preserveLinebreaks:i',
    'saveXML:i',                        'sidebarWidth:s',
    'datapath:s',                       'cssTemplateDirectory:s',
    'cssTemplate:s',                    'xslTemplateDirectory:s',
    'xslTemplateForClasses:s',          'xslTemplateForIndexFrameset:s',
    'xslTemplateForPackagesFrameset:s', 'xslTemplateForPackagesTocFrameset:s',
    'feedback:i',
);

# only for VisDoc.pm
$preferences->{'base'} = getcwd();

# not used in further processing:
delete $preferences->{'out'};
delete $preferences->{'process'};
my $dataPath = $preferences->{'datapath'};
delete $preferences->{'datapath'};

=pod
eval "use Data::Dumper";
if ($@) {
    print STDOUT $@;
    die;
}
=cut
#print STDOUT "Using preferences:" . Dumper($preferences);
#print STDOUT "process=$process \n";
#print STDOUT "out=$out \n";

my $error = '';

eval "use VisDoc::Logger";
if ($@) {
    print STDOUT $@;
    die;
}
VisDoc::Logger->clear();

# store processed files:
my $collectiveFileData;

# the list of files and dirs to process

my $validExtensions;
map { $validExtensions->{$_} = 1; }
  split( /\s*,\s*/, $preferences->{'extensions'} );
my @fileList = split( /\s*,\s*/, $process );
my $files = VisDoc::FileUtils::getFiles( \@fileList, $validExtensions );
$error .= "No files to process\n" unless $files;

eval '$collectiveFileData = VisDoc::parseFiles($files)';

$error .= "No files processed\n" unless $collectiveFileData;
if ($@) {
    $error .= $@;
}

VisDoc::Logger::logTime( $startTime, time() )
  if $preferences->{'feedback'};

# write out
my $result = '';
if ($collectiveFileData) {
    my $writePath = File::Spec->rel2abs($out);
    my ( $htmlDir, $indexHtml, $htmlDocFileNames, $htmlSupportingFileNames );

    eval
'($htmlDir, $indexHtml, $htmlDocFileNames, $htmlSupportingFileNames) = VisDoc::writeData( $writePath, $collectiveFileData, $preferences );';
    if ($@) {
        $error .= $@;
    }

    if ($dataPath) {

        # htmlDir
        if ($htmlDir) {
            $result .= 'htmlDir="' . $htmlDir . '";' . "\n";
        }

        # index
        if ($indexHtml) {
            $result .= 'index="' . $indexHtml . '";' . "\n";
        }

        # classes
        if ( $htmlDocFileNames && scalar @{$htmlDocFileNames} ) {
            my %htmlDocFileNamesData = map { $_ => 1 } @{$htmlDocFileNames};
            my $htmlDocFileNamesString =
              VisDoc::CocoaUtils::createPropertyListFromData(
                \%htmlDocFileNamesData );
            $result .= "classes=$htmlDocFileNamesString;\n";
        }

        # other html files
        if ( $htmlSupportingFileNames && scalar @{$htmlSupportingFileNames} ) {
            my %htmlSupportingFileNamesData =
              map { $_ => 1 } @{$htmlSupportingFileNames};
            my $htmlSupportingFileNamesString =
              VisDoc::CocoaUtils::createPropertyListFromData(
                \%htmlSupportingFileNamesData );
            $result .= "supporting=$htmlSupportingFileNamesString;\n";
        }
    }
}

if ($error) {
    $result .= 'error="' . $error . '";' . "\n";
}
if ( $preferences->{'feedback'} ) {
    my $log = VisDoc::Logger::getLogText();
    $log =~ s/[[:space:]]+$//s;    # trim at end
    $result .= 'log="' . $log . '";';
    VisDoc::CocoaUtils::writeStringToFile( $dataPath, $result );
}
1;
