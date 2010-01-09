package VisDoc::Language;

use strict;
use JSON;

our $docTerms;
our $javadocTerms;

our $DEFAULT_DOC_TERM_LANGUAGE = 'default';

sub initDocTerms {
    my ($inJsonText) = @_;

    my $json = new JSON;	
    # allow # comments
    $json = $json->relaxed( [1] );
    $docTerms = $json->decode($inJsonText);
}

sub getDocTerm {
    my ( $inKey, $inLanguage ) = @_;

    my $language = $inLanguage || $DEFAULT_DOC_TERM_LANGUAGE;
    my $term = $docTerms->{$inKey}->{$language};
    $term = $docTerms->{$inKey}->{$DEFAULT_DOC_TERM_LANGUAGE} if !$term;
    return $term;
}

sub initJavadocTerms {
    my ($inJsonText) = @_;

    my $json = new JSON;

    # allow # comments
    $json = $json->relaxed( [1] );
    $javadocTerms = $json->decode($inJsonText);
}

sub getJavadocTerm {
    my ($inKey) = @_;

    return $javadocTerms->{$inKey};
}

1;
