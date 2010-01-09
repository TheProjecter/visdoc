package VisDoc::MemberFormatterFactory;

use strict;
use VisDoc::ParserAS2;
use VisDoc::ParserAS3;
use VisDoc::ParserJava;

=pod

getMemberFormatterForLanguage( $languageId ) -> $memberFormatter

=cut

sub getMemberFormatterForLanguage {
	my ($inLanguage) = @_;

    require VisDoc::MemberFormatterAS2;
    if ( $inLanguage eq $VisDoc::ParserAS2::ID ) {
    	my VisDoc::MemberFormatterAS2 $formatter = VisDoc::MemberFormatterAS2->new();
        return $formatter;
    }
    require VisDoc::MemberFormatterAS3;
    if ( $inLanguage eq $VisDoc::ParserAS3::ID ) {
        my VisDoc::MemberFormatterAS3 $formatter = VisDoc::MemberFormatterAS3->new();
        return $formatter;
    }
    require VisDoc::MemberFormatterJava;
    if ( $inLanguage eq $VisDoc::ParserJava::ID ) {
        my VisDoc::MemberFormatterJava $formatter = VisDoc::MemberFormatterJava->new();
        return $formatter;
    }
}

1;