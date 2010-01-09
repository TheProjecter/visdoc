package VisDoc::Formatter;

use strict;
use VisDoc::FormatterBase;
use VisDoc::FormatterAS2;
use VisDoc::FormatterAS3;
use VisDoc::FormatterJava;

our VisDoc::FormatterAS2 $FORMATTER_AS2;
our VisDoc::FormatterAS3 $FORMATTER_AS3;
our VisDoc::FormatterJava $FORMATTER_JAVA;

=pod

StaticMethod formatter ($language ) -> $formatter

Formatter factory method.

$language: language id

my $formatter = VisDoc::Formatter::formatter( $language );

=cut

sub formatter {
    my ($inLanguage) = @_;

    if ( $inLanguage eq 'as2' ) {
        $FORMATTER_AS2 = VisDoc::FormatterAS2->new() if !$FORMATTER_AS2;
        return $FORMATTER_AS2;
    }
    if ( $inLanguage eq 'as3' ) {
        $FORMATTER_AS3 = VisDoc::FormatterAS3->new() if !$FORMATTER_AS3;
        return $FORMATTER_AS3;
    }
    if ( $inLanguage eq 'java' ) {
        $FORMATTER_JAVA = VisDoc::FormatterJava->new() if !$FORMATTER_JAVA;
        return $FORMATTER_JAVA;
    }

    die "No formatter found for language $inLanguage";
}

1;
