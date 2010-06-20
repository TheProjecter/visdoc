#! /usr/bin/perl -w
#
# See bottom of file for license and copyright information

use strict;
use warnings;
use File::Spec;
use Getopt::Long;
use Pod::Usage;
use Cwd 'getcwd';

# Show help
Getopt::Long::Configure( "no_auto_abbrev", "no_ignore_case" );

sub usage {
    pod2usage( { -verbose => 2, -input => \*DATA } );
    exit;
}
usage() if ( scalar @ARGV == 0 );

BEGIN {
    my $here = Cwd::abs_path;
    my $root = $here;
    push @INC, "$root/lib/CPAN/lib";
	push @INC, "$root/lib";
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
eval "use VisDoc::OSX::CocoaUtils";
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
my $startTime   = time();
my $out         = '';
my $process     = '';
my $preferences = $VisDoc::Defaults::SETTINGS;
my $unused      = $VisDoc::Defaults::SETTINGS
  ;    # to remove the 'used only once' message we otherwise get

$preferences->{'output'}      = \$out;
$preferences->{'doc-sources'} = \$process;

&GetOptions(
    $preferences,                          'output=s',
    'doc-sources=s',                       'copyCSS:i',
    'copyright:i',                         'copyrightText|footer:s',
    'extensions:s',                        'eventHandlerPrefixes:s',
    'eventHandlers:i',                     'generateIndex:i',
    'ignoreClasses:i',                     'includeSourceCode:i',
    'indexTitle|main-title:s',             'listPrivate:i',
    'preserveLinebreaks:i',                'saveXML:i',
    'sidebarWidth:s',                      'datapath:s',
    'templateCssDirectory:s',              'templateCss:s',
    'templateJsDirectory:s',
    'templateXslDirectory:s',              'templateXslForClasses:s',
    'templateXslForIndexFrameset:s',       'templateXslForPackagesFrameset:s',
    'templateXslForPackagesTocFrameset:s', 'feedback:i',
    'openInBrowser:i',
    'help'
);

usage() if $preferences->{help};

# only for VisDoc.pm
$preferences->{'base'} = getcwd();

# not used in further processing:

my $dataPath = $preferences->{'datapath'};
delete $preferences->{'datapath'};

$preferences->{copyrightText} ||= $preferences->{footer};
$preferences->{indexTitle} ||= $preferences->{'main-title'};

=pod
eval "use Data::Dumper";
if ($@) {
    print STDOUT $@;
    die;
}
print STDOUT "Using preferences:" . Dumper($preferences);
print STDOUT "process=$process \n";
print STDOUT "out=$out \n";
=cut

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

eval '$collectiveFileData = VisDoc::parseFiles($files, undef, $preferences)';

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
              VisDoc::OSX::CocoaUtils::createPropertyListFromData(
                \%htmlDocFileNamesData );
            $result .= "classes=$htmlDocFileNamesString;\n";
        }

        # other html files
        if ( $htmlSupportingFileNames && scalar @{$htmlSupportingFileNames} ) {
            my %htmlSupportingFileNamesData =
              map { $_ => 1 } @{$htmlSupportingFileNames};
            my $htmlSupportingFileNamesString =
              VisDoc::OSX::CocoaUtils::createPropertyListFromData(
                \%htmlSupportingFileNamesData );
            $result .= "supporting=$htmlSupportingFileNamesString;\n";
        }
    }
    if ($preferences->{'openInBrowser'}) {
    	if ($indexHtml) {
	    	system(qq(open "$htmlDir/$indexHtml.html"));
	    } else {
	    	my $doc = $htmlDocFileNames->[0];
	    	system(qq(open "$htmlDir/$doc.html"));
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
    VisDoc::OSX::CocoaUtils::writeOut( $result, $dataPath );
}

1;

__DATA__

=head1 SYNOPSIS

Parses code files and generates html documentation.
 
=head1 USAGE

VisDoc.pl [options]

=head1 OPTIONS

=over 8

=item B<-help>

Shows this help text

=item B<-doc-sources>

Comma-separated list of source files to process.
Value: string

=item B<-output>

Directory path to write documentation files in. In the directory the subdirectories 'css', 'html', 'js' and optionally 'xml' will be created.
Value: string

=item B<-copyCSS>

Whether to copy the default CSS file to the output directory.
Values: 1 or 0
Default: 1 (file is copied)

=item B<-footer>

Footer text.
Value: HTML string. To write a copyright sign, use &copy;.
Default: none (no footer)

=item B<-extensions>

Comma-separated list of file extensions. Only files with those file extensions will used. If not passed, all files will be processed.

=item B<-eventHandlers>

To write...

=item B<-eventHandlerPrefixes>

Distinguish event handlers by given prefixes.
Value: string in quotes
Default: "on,allow"

=item B<-includeSourceCode>

Whether to include source code in the documentation.
Values: 1 or 0
Default: 0

=item B<-main-title>

Title of frameset and main.html header.
Value: string
Default: none, no frameset

=item B<-sidebarWidth>

Width of left bar in percentage or pixels.
Value: a number appended with px or %
Default: "22%"

=item B<-listPrivate>

Whether to list private members.
Values: 1 or 0
Default: 0

=item B<-preserveLinebreaks>

Whether to treat linebreaks as hard returns.
Values: 1 or 0
Default: 0

=item B<-saveXML>

To write...

=item B<-templateCssDirectory>

To write...

=item B<-templateCss>

To write...

=item B<-templateXslDirectory>

To write...

=item B<-templateXslForIndexFrameset>

To write...

=item B<-templateXslForPackagesFrameset>

To write...

=item B<-templateXslForPackagesTocFrameset>

To write...

=item B<-feedback>

Whether to write out processing feedback.
Values: 1 or 0
Default: 0

=item B<-ignoreClasses>

Not implemented.

=item B<-openInBrowser>

Whether to open generated documentation in a browser.

Values: 1 or 0
Default: 0

=cut


# VisDoc - Code documentation generator, http://visdoc.org
# This software is licensed under the MIT License
#
# The MIT License
#
# Copyright (c) 2010 Arthur Clemens, VisDoc contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
