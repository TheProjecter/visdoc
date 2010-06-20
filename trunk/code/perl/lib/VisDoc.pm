# See bottom of file for license and copyright information

package VisDoc;

use strict;
use warnings;
use utf8;
use File::Spec;
use File::Slurp qw( slurp write_file );
use File::Path;
use File::Copy;
use File::Find;
use File::stat;
use XML::LibXSLT;
use XML::LibXML;
use VisDoc::FileParser;
use VisDoc::FileData;
use VisDoc::OutputFormatter;
use VisDoc::XMLOutputFormatterMainPage;
use VisDoc::XMLOutputFormatterIndex;
use VisDoc::XMLOutputFormatterEmptyFrame;
use VisDoc::XMLOutputFormatterToc;
use VisDoc::XMLOutputFormatterOverviewTree;
use VisDoc::XMLOutputFormatterAllClassesFrame;
use VisDoc::XMLOutputFormatterAllMethodsFrame;
use VisDoc::XMLOutputFormatterAllConstantsFrame;
use VisDoc::XMLOutputFormatterAllPropertiesFrame;
use VisDoc::XMLOutputFormatterAllDeprecatedFrame;
use VisDoc::XMLOutputFormatterTocPackages;
use VisDoc::XMLOutputFormatterPackageToc;
use VisDoc::Defaults;
use VisDoc::HashUtils;
use VisDoc::PostParser;
use VisDoc::Logger;

my $VERSION = '3.0';

=pod

StaticMethod readFile($path) -> $text

Utility method. Returns the file contents of file at path $inFilePath.

=cut

sub readFile {
    my ($inFilePath) = @_;

    my ($exists) = stat($inFilePath);
    if ( !$exists ) {
        return '';
    }

    my $text = slurp( $inFilePath, binmode => ':utf8', err_mode => 'carp' );
    if ( !$text ) {
        return '';
    }
    return $text;
}

=pod

StaticMethod parseText( $text, $language ) -> $fileData

- param $language: optional

=cut

sub parseText {
    my ( $inText, $inLanguage ) = @_;

    my @texts = ($inText);
    return parseTexts( \@texts, $inLanguage )->[0];
}

=pod

parseTexts( \@texts, $language ) -> \@fileData

- param $language: optional

=cut

sub parseTexts {
    my ( $inTexts, $inLanguage ) = @_;

    my $collectiveFileData;
    foreach my $text ( @{$inTexts} ) {
        my $fileParser = VisDoc::FileParser->new();
        push @{$collectiveFileData},
          $fileParser->parseText( $text, $inLanguage );
    }
    return VisDoc::PostParser::process($collectiveFileData);
}

=pod

StaticMethod parseFile( $file, $language ) -> $fileData

- param $language: optional

=cut

sub parseFile {
    my ( $inPath, $inLanguage ) = @_;

    my @files = ($inPath);
    return parseFiles( \@files, $inLanguage )->[0];
}

=pod

parseFiles( \@files, $language ) -> \@fileData

- param $language: optional

=cut

sub parseFiles {
    my ( $inFiles, $inLanguage, $inPreferences ) = @_;

    my $collectiveFileData;
    foreach my $file ( @{$inFiles} ) {

        # check if file exists
        next unless -e $file;
        my $fileParser = VisDoc::FileParser->new();
        my $fileData = $fileParser->parseFile( $file, $inLanguage );
        if ( defined $fileData ) {
            push @{$collectiveFileData}, $fileData;
            VisDoc::Logger::logParsedFile($file);
        }
    }
    return VisDoc::PostParser::process($collectiveFileData, $inPreferences);
}

=pod

StaticMethod validateFile( $file ) -> {valid => $bool, modificationDate => $date, language => $language }

File must exist.

=cut

sub validateFile {
    my ($inPath) = @_;

    my $fileParser = VisDoc::FileParser->new();
    my ( $fileData, $fileText ) = $fileParser->getFileData( $inPath, undef );

    # crude validity check: if a language is found we assume it is valid
    my $valid = defined $fileData->{language};

    return {
        valid            => $valid,
        modificationDate => $fileData->{modificationDate},
        language         => $fileData->{language}
    };
}

=pod

StaticMethod writeData ($directory, $collectiveFileData, \%preferences) -> ($index, \@htmlDocFileNames, \@htmlSupportingFileNames)

TOCs:

index.html
	= frameset
	as2: no packages => 
	as3, java: packages => toc-frame.html

toc-frame.html
	= frameset, loads: overview-frame.html and empty-frame.html

=cut

sub writeData {
    my ( $inDocDirectory, $inCollectiveFileData, $inPreferences ) = @_;

    my $dirInfo = _createWriteDirectories( $inDocDirectory, $inPreferences );
    _copyAssets( $dirInfo, $inPreferences );

    my $baseDir    = $inPreferences->{base};
    my $xsltDir    = $inPreferences->{templateXslDirectory} || $baseDir;
    my $processing = {
        'classes' => {
            xsltRef => _getXslt(
                'class', $xsltDir, $inPreferences->{templateXslForClasses}
            ),
            xmls => undef,    # array of hashes with keys 'uri' and 'textRef'
        },
        'main' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls => undef,    # array of hashes with keys 'uri' and 'textRef'
        },
        'index-frameset' => {
            xsltRef => _getXslt( 'index-frameset', $xsltDir ),
            xmls => undef,    # array of hashes with keys 'uri' and 'textRef'
        },
        'packages-frameset' => {
            xsltRef => _getXslt( 'packages-frameset', $xsltDir ),
            xmls => undef,    # array of hashes with keys 'uri' and 'textRef'
        },
        'packages-toc-frameset' => {
            xsltRef => _getXslt( 'packages-toc-frameset', $xsltDir ),
            xmls    => undef,
        },
        'toc' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'toc-packages' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'empty-frame' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'package-toc' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'overview-tree' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'methods' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'constants' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'properties' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
        'deprecated' => {
            xsltRef => _getXslt( 'class', $xsltDir ),
            xmls    => undef,
        },
    };

    # parse data to xml
    my $indexHtml = undef;
    my @htmlDocFileNames;
    my @htmlSupportingFileNames;

    # classes
    foreach my $fileData ( @{$inCollectiveFileData} ) {

        # get (potentially multiple) xml texts from each FileData
        my $xmlData =
          VisDoc::OutputFormatter::formatFileData( $fileData, $inPreferences );
        my $key = 'classes';

        # store
        map { push( @{ $processing->{$key}->{xmls} }, $_ ) } @{$xmlData};
        map { push( @htmlDocFileNames, $_->{uri} ) } @{$xmlData};
    }

    if ( $inPreferences->{generateIndex} ) {

        my $tocNavigationKeys = {
            'main'          => undef,
            'overview-tree' => undef,
            'classes'       => undef,
            'methods'       => undef,
            'constants'     => undef,
            'properties'    => undef,
            'deprecated'    => undef,
        };
        my $addToTocNavigation = sub {
            my ($inKey) = @_;
            $tocNavigationKeys->{$inKey} = 1;
        };

        {

            # main.html
            my $xmlData = _createMainHtmlPageXmlData( $dirInfo->{dir}->{html},
                $inPreferences, $inCollectiveFileData );
            my $key = 'main';
            push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
            push( @htmlSupportingFileNames, $xmlData->{uri} ) if $xmlData;

            #
            &$addToTocNavigation($key);
        }

        my $processOverviewPage = sub {
            my ( $inFormatterName, $inKey ) = @_;

            my $formatter =
              $inFormatterName->new( $inPreferences, $inCollectiveFileData );
            my $xmlData = $formatter->format();
            push( @{ $processing->{$inKey}->{xmls} }, $xmlData ) if $xmlData;
            push( @htmlSupportingFileNames, $xmlData->{uri} ) if $xmlData;
            &$addToTocNavigation($inKey) if $xmlData->{hasFormattedData};
        };

        # process overview pages
        &$processOverviewPage( 'VisDoc::XMLOutputFormatterOverviewTree',
            'overview-tree' );
        &$processOverviewPage( 'VisDoc::XMLOutputFormatterAllClassesFrame',
            'classes' );
        &$processOverviewPage( 'VisDoc::XMLOutputFormatterAllMethodsFrame',
            'methods' );
        &$processOverviewPage( 'VisDoc::XMLOutputFormatterAllConstantsFrame',
            'constants' );
        &$processOverviewPage( 'VisDoc::XMLOutputFormatterAllPropertiesFrame',
            'properties' );
        &$processOverviewPage( 'VisDoc::XMLOutputFormatterAllDeprecatedFrame',
            'deprecated' );

        my $packagesCount = 0;
        foreach my $fileData ( @{$inCollectiveFileData} ) {
            foreach my $package ( @{ $fileData->{packages} } ) {
                $packagesCount++ if $package->{name};
                last if $packagesCount > 0;
            }
        }

        if ( $packagesCount > 0 ) {

            {

                # index.html - packages frameset
                my $formatter =
                  VisDoc::XMLOutputFormatterIndex->new( $inPreferences,
                    'index' );
                my $xmlData = $formatter->format();
                my $key     = 'packages-frameset';
                push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
                $indexHtml = $xmlData->{uri} if $xmlData;
            }
            {

                # toc-frame.html - packages frameset
                my $formatter =
                  VisDoc::XMLOutputFormatterIndex->new( $inPreferences,
                    'toc-frame' );
                my $xmlData = $formatter->format();
                my $key     = 'packages-toc-frameset';
                push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
                push( @htmlSupportingFileNames, $xmlData->{uri} ) if $xmlData;
            }
            {

                # overview-frame.html
                my $formatter =
                  VisDoc::XMLOutputFormatterTocPackages->new( $inPreferences,
                    undef, $inCollectiveFileData, $tocNavigationKeys );
                my $xmlData = $formatter->format();
                my $key     = 'toc-packages';
                push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
                push( @htmlSupportingFileNames, $xmlData->{uri} ) if $xmlData;
            }
            {

                # empty-frame.html
                my $formatter =
                  VisDoc::XMLOutputFormatterEmptyFrame->new( $inPreferences,
                    $inCollectiveFileData );
                my $xmlData = $formatter->format();
                my $key     = 'empty-frame';
                push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
                push( @htmlSupportingFileNames, $xmlData->{uri} ) if $xmlData;
            }

            # create TOC for each package
            foreach my $fileData ( @{$inCollectiveFileData} ) {
                foreach my $package ( @{ $fileData->{packages} } ) {
                    my $formatter =
                      VisDoc::XMLOutputFormatterPackageToc->new( $inPreferences,
                        $fileData->{language}, $package );
                    my $xmlData = $formatter->format();
                    my $key     = 'package-toc';
                    push( @{ $processing->{$key}->{xmls} }, $xmlData )
                      if $xmlData;
                    push( @htmlSupportingFileNames, $xmlData->{uri} )
                      if $xmlData;
                }
            }

        }
        else {

            {

                # index.html frameset
                my $formatter =
                  VisDoc::XMLOutputFormatterIndex->new( $inPreferences,
                    'index' );
                my $xmlData = $formatter->format();
                my $key     = 'index-frameset';
                push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
                $indexHtml = $xmlData->{uri} if $xmlData;
            }
            {

                # toc.html
                my $formatter =
                  VisDoc::XMLOutputFormatterToc->new( $inPreferences, undef,
                    $inCollectiveFileData, $tocNavigationKeys );
                my $xmlData = $formatter->format();
                my $key     = 'toc';
                push( @{ $processing->{$key}->{xmls} }, $xmlData ) if $xmlData;
                push( @htmlSupportingFileNames, $xmlData->{uri} ) if $xmlData;
            }
        }

    }

    # write everything to files
    while ( my ( $key, $value ) = each %{$processing} ) {

        foreach my $xml ( @{ $value->{xmls} } ) {

            # write XML
            _writeXmlDataFile( $dirInfo->{dir}->{xml},
                "$xml->{uri}.xml", $xml->{textRef} )
              if $inPreferences->{saveXML};

            # write HTML
            my $htmlRef =
              _transformXmlToHtml( $xml->{textRef}, $value->{xsltRef} );
            _cleanupHtml($htmlRef);
            _writeHtmlFile( $dirInfo->{dir}->{html},
                "$xml->{uri}.html", $htmlRef );
        }

    }
    return ( $dirInfo->{dir}->{html},
        $indexHtml, \@htmlDocFileNames, \@htmlSupportingFileNames );
}

=pod

StaticMethod _createWriteDirectories ($directory, \%preferences) -> \%info

=cut

sub _createWriteDirectories {
    my ( $inDocDirectory, $inPreferences ) = @_;

    my $info       = {};
    my $isValidDir = 0;
    my $dir        = '';

    my $base = $inPreferences->{base};
    $info->{base} = $base;

    if ( $inPreferences->{saveXML} ) {
        $dir = _createSubDirectory( $inDocDirectory, $base, 'xml' );
        $isValidDir = defined stat($dir) ? 1 : 0;
        $info->{dir}->{xml}     = $dir;
        $info->{xml}->{isValid} = $isValidDir;
    }

    $dir = _createSubDirectory( $inDocDirectory, $base, 'html' );
    $info->{dir}->{html} = $dir;

    $dir = _createSubDirectory( $inDocDirectory, $base, 'css' )
      if $inPreferences->{copyCSS};
    $info->{dir}->{css} = $dir;

    $dir = _createSubDirectory( $inDocDirectory, $base, 'js' );
    $info->{dir}->{js} = $dir;

=pod
	$dir = '';
    $dir = _createSubDirectory( $inDocDirectory, $base, 'img' );
    $info->{img} = $dir;
=cut

    return $info;
}

=pod

StaticMethod _copyAssets(\%directoryInfo, \%preferences )

=cut

sub _copyAssets {
    my ( $inDirectoryInfo, $inPreferences ) = @_;

    # copy css
    _copyCss( $inDirectoryInfo->{dir}->{css}, $inPreferences );

    # copy js
    _copyJs( $inDirectoryInfo->{dir}->{js}, $inPreferences );
}

=pod

StaticMethod _createSubDirectory( $docDirectory, $baseDirectory, $subDirectory ) -> $createdPath

Util method to create a sub directory below the doc directory.

=cut

sub _createSubDirectory {
    my ( $inDocDirectory, $inBaseDirectory, $inSubDirectory ) = @_;

    my $docDirectoryPath =
      File::Spec->rel2abs( $inDocDirectory, $inBaseDirectory );
    my $path = File::Spec->catdir( $docDirectoryPath, $inSubDirectory );

    my $result;
    eval { $result = File::Path::mkpath($path) };
    if ($@) {
        print "Could not create dir: $@\n";
    }
    return $path;
}

=pod

StaticMethod _writeXmlDataFile ( $xmlDirectory, $fileName, \$xmlText )

Writes XML text to file $fileName.

=cut

sub _writeXmlDataFile {
    my ( $inXmlDirectory, $inFileName, $inXmlTextRef ) = @_;

    # append the filename to the path
    my $writePath = File::Spec->catpath( '', $inXmlDirectory, $inFileName );
    File::Slurp::write_file( $writePath, { atomic => 1 }, $$inXmlTextRef );
}

=pod

StaticMethod _writeHtmlFile ( $htmlDirectory, $fileName, \$htmlText )

Writes HTML text to file $fileName.

=cut

sub _writeHtmlFile {
    my ( $inHtmlDirectory, $inFileName, $inHtmlText ) = @_;

    # append the filename to the path
    my $writePath = File::Spec->catpath( '', $inHtmlDirectory, $inFileName );
    File::Slurp::write_file( $writePath, { atomic => 1 }, $inHtmlText );
}

=pod

StaticMethod _copyCss ( $destinationDir, \%preferences )

Uses template css from %preferences (property 'cssFile'), otherwise uses default $VisDoc::Defaults::FILE_CSS_TEMPLATE.

=cut

sub _copyCss {
    my ( $inDestinationDir, $inPreferences ) = @_;

    return if !$inPreferences->{copyCSS};

    my $cssTemplateDir = $inPreferences->{'templateCssDirectory'}
      || $VisDoc::Defaults::SETTINGS->{'templateCssDirectory'};

    my $fileName = $inPreferences->{templateCss}
      || $VisDoc::Defaults::SETTINGS->{'templateCss'};

    my $path =
      File::Spec->rel2abs( "$cssTemplateDir/$fileName",
        $inPreferences->{base} );

    die "No such file $path" unless -e $path;

    my $result = File::Copy::copy( $path, $inDestinationDir );
    if ( !$result ) {
        print("Could not copy $path to $inDestinationDir: $!\n");
    }

    my $dir = File::Spec->rel2abs( $cssTemplateDir, $inPreferences->{base} );

    # get all files from the css template directory
    my @files;
    File::Find::find(
        {
            wanted => sub {

                # check if file is javascript file
                push @files, $File::Find::name
                  if ( $File::Find::name =~ /(\.css|\.png|\.gif|\.jpg)$/i );
            },
        },
        $dir
    );

    foreach my $copyFile (@files) {
        my $copyPath = File::Spec->rel2abs( $copyFile, $inPreferences->{base} );
        my $copyResult = File::Copy::copy( $copyPath, $inDestinationDir );
        if ( !$copyResult ) {
            print("Could not copy $copyPath to $inDestinationDir: $!\n");
        }
    }
}

=pod

StaticMethod _copyJs ( $destinationDir, \%preferences )

Copies javascript files from the template directory to $destinationDir.

=cut

sub _copyJs {
    my ( $inDestinationDir, $inPreferences ) = @_;

    my $dir = File::Spec->rel2abs( $VisDoc::Defaults::FILE_JS_TEMPLATE_DIR,
        $inPreferences->{base} );

    # get all .js files from that directory
    my @files;
    File::Find::find(
        {
            wanted => sub {

                # check if file is javascript file
                push @files, $File::Find::name
                  if ( $File::Find::name =~ /(\.js)$/ );
            },
        },
        $dir
    );

    foreach my $file (@files) {
        my $path = File::Spec->rel2abs( $file, $inPreferences->{base} );
        my $result = File::Copy::copy( $path, $inDestinationDir );
        if ( !$result ) {
            print("Could not copy $path to $inDestinationDir: $!\n");
        }
    }
}

=pod

StaticMethod _getXslt( $type, $xsltDir, $xsltFile ) -> $textRef

Reads XSLT text from file.

$type: 'class', 'index', 'packages' or 'packages_toc'

=cut

sub _getXslt {
    my ( $inType, $inXsltDir, $inXsltFile ) = @_;

    my $xsltFile;
    if ($inXsltFile) {
        $xsltFile = $inXsltFile;
    }
    else {
        $xsltFile = $VisDoc::Defaults::SETTINGS->{'templateXslForClasses'}
          if ( $inType eq 'class' );
        $xsltFile = $VisDoc::Defaults::SETTINGS->{'templateXslForIndexFrameset'}
          if ( $inType eq 'index-frameset' );
        $xsltFile =
          $VisDoc::Defaults::SETTINGS->{'templateXslForPackagesFrameset'}
          if ( $inType eq 'packages-frameset' );
        $xsltFile =
          $VisDoc::Defaults::SETTINGS->{'templateXslForPackagesTocFrameset'}
          if ( $inType eq 'packages-toc-frameset' );
    }

    my $xsltPath = File::Spec->rel2abs( $xsltFile, $inXsltDir );

    die "No such file $xsltPath" unless -e $xsltPath;

    my $xsltText = readFile($xsltPath);

    die("Could not load XSL file: $xsltPath\n") if !$xsltText;

    return \$xsltText;
}

=pod

StaticMethod _transformXmlToHtml( \$xmlText, \$classXsltText ) -> \$html

Transforms XML to HTML using XSLT.
Uses LbXML engine (must be installed).

=cut

sub _transformXmlToHtml {
    my ( $inXmlTextRef, $inClassXsltTextRef ) = @_;

    my $parser = XML::LibXML->new();

    my $source    = $parser->parse_string($$inXmlTextRef);
    my $style_doc = $parser->parse_string($$inClassXsltTextRef);

    # TODO: this could be optimized so that this is called only once per session
    my $xslt       = XML::LibXSLT->new();
    my $stylesheet = $xslt->parse_stylesheet($style_doc);

    my $results   = $stylesheet->transform($source);
    my $outString = $stylesheet->output_as_bytes($results);

    return \$outString;
}

=pod

StaticMethod _createMainHtmlPageXmlData( $htmlDirectory, \%preferences, \@collectiveFileData ) -> { uri => ..., textRef => ... }

Creates main.html if it does not exist yet.
If it does exist, checks the version number (in meta). If older, updates the html and saves.

=cut

sub _createMainHtmlPageXmlData {
    my ( $inHtmlDirectory, $inPreferences, $inCollectiveFileData ) = @_;

    my $file = "$inHtmlDirectory/main.html";
    my $path = File::Spec->rel2abs( $file, $inPreferences->{base} );

    use File::stat;
    my $st = stat($path);
    if ($st) {
        my $fileText = readFile($path);

        my $check = "<meta name=\"VERSION\" content=\"$VERSION\" \/>";
        if ( $fileText =~ m/$check/ ) {

            # is recent
            return undef;
        }

        # convert old js code to new
        my $pattern;
        my $replacement;

        my $meta =
'<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';
        $pattern     = $meta;
        $replacement = "$meta$check";
        $fileText =~ s/$pattern/$replacement/go;

        $pattern =
          '<script src="../js/behaviour.js" type="text/javascript">//</script>';
        $replacement =
          '<script src="../js/jquery.js" type="text/javascript">//</script>';
        $fileText =~ s/$pattern/$replacement/go;

        $pattern = '<div id="toggleTOC_off"';
        $replacement =
'<span id="twistyTOC_toggle" class="twistyContent"><!----></span><div id="toggleTOC_off"';
        $fileText =~ s/$pattern/$replacement/go;

        $pattern     = 'toggleTOC_on';
        $replacement = 'twistyTOC_show';
        $fileText =~ s/$pattern/$replacement/go;

        $pattern     = 'toggleTOC_off';
        $replacement = 'twistyTOC_hide';
        $fileText =~ s/$pattern/$replacement/go;

        $pattern = 'toggleTrigger toggleMakeVisible';
        $replacement =
          'twistyTrigger visdocUnvisited visdocMakeVisible twistyInited';
        $fileText =~ s/$pattern/$replacement/go;

        _writeHtmlFile( $inHtmlDirectory, 'main.html', \$fileText );
        return;
    }

    # does not exist yet
    my $formatter = VisDoc::XMLOutputFormatterMainPage->new( $inPreferences,
        $inCollectiveFileData );
    return $formatter->format();
}

sub _cleanupHtml {
    my ($htmlRef) = @_;

    VisDoc::StringUtils::trimSpaces($$htmlRef);

    # remove space before span
    # commented out because this messes up spans inside pre blocks
    #$$htmlRef =~ s/[[:space:]]+(<span)/ $1/go;
}

1;

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
