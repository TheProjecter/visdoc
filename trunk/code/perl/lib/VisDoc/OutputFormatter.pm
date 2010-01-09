package VisDoc::OutputFormatter;

use strict;
use VisDoc::FileData;
use VisDoc::Defaults;
use VisDoc::XMLOutputFormatterClassData;
use VisDoc::XMLOutputFormatterPackageData;
use VisDoc::Language;

=pod

StaticMethod format ($fileData ) -> \@xmlData

Returns an array of xmlData hashes, each with keys:
- uri: the uri (without file extension)
- textRef: reference to the XML text

=cut

my $doctermsInited =0 ;

sub formatFileData {
    my ( $inFileData, $inPreferences ) = @_;

    _initDocTerms( $inPreferences->{base} );

    my $xmlData;    # array ref

    foreach my $packageData ( @{ $inFileData->{packages} } ) {

    	next if $packageData->isExcluded();
        next if !$inPreferences->{listPrivate} && !$packageData->isPublic();
        
        # package
        if ( $packageData->{name} ) {

            # excludes unmaterialized packages, such as with as2
            my $formatter =
              VisDoc::XMLOutputFormatterPackageData->new( $inPreferences,
                $inFileData->{language}, $packageData );
            push @{$xmlData}, $formatter->format();
        }

        # class
        foreach my $classData ( @{ $packageData->{classes} } ) {
        	next if $classData->isExcluded();
        	next if !$inPreferences->{listPrivate} && !$classData->isPublic();
            my $formatter =
              VisDoc::XMLOutputFormatterClassData->new( $inPreferences,
                $inFileData->{language}, $classData );
            push @{$xmlData}, $formatter->format();
        }

    }
    return $xmlData;
}

=pod

=cut

sub _initDocTerms {
    my ($inBase) = @_;

	return if $doctermsInited;
	
    {

        # docterms
        my $path =
          File::Spec->rel2abs( $VisDoc::Defaults::FILE_DOCTERMS, $inBase );
        my $text = VisDoc::readFile($path);
        VisDoc::Language::initDocTerms($text);
    }
    {

        # docterms
        my $path =
          File::Spec->rel2abs( $VisDoc::Defaults::FILE_JAVADOCTERMS, $inBase );
        my $text = VisDoc::readFile($path);
        VisDoc::Language::initJavadocTerms($text);
    }
    
    $doctermsInited = 1;
}

1;
