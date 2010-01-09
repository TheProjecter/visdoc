# old VisDoc: simple toc

package VisDoc::XMLOutputFormatterToc;
use base 'VisDoc::XMLOutputFormatterTocBase';

use strict;
use XML::Writer;

=pod

=cut

sub _uri {
    my ($this) = @_;

    return 'toc';
}

sub _title {
    my ($this) = @_;

	return VisDoc::Language::getDocTerm('all_classes_simpletoc_title', $this->{language});
}

1;

