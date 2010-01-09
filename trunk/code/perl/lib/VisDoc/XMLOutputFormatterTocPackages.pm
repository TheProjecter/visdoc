# old VisDoc: overview frame

package VisDoc::XMLOutputFormatterTocPackages;
use base 'VisDoc::XMLOutputFormatterToc';

use strict;
use XML::Writer;

=pod

=cut

sub _uri {
    my ($this) = @_;

    return 'overview-frame';
}

sub _title {
    my ($this) = @_;

	return VisDoc::Language::getDocTerm('toc_packages_title', $this->{language});
}

=pod

=cut

sub _writeTargetMarker {
    my ( $this, $inWriter ) = @_;

	$inWriter->cdataElement('tocMarkerOverviewFrame', 'true');
	
}

=pod

_writeListData ($xmlWriter, $classData) -> $bool

=cut

sub _writeListData {
    my ( $this, $inWriter ) = @_;
    
    $inWriter->startTag('tocList');
    $inWriter->startTag('listGroup');
    
    my $packages;
    foreach my $fileData (@{$this->{data}}) {
    	foreach my $package (@{$fileData->{packages}}) {
			push @$packages, $package;
    	}
    }
    
    # sort packages
    @{$packages} =
          sort { lc($a->{name}) cmp lc($b->{name}) } @{$packages};
    
    my $path = '';
    foreach my $package (@{$packages}) {
    	next if $package->isExcluded();
        next if !$this->{preferences}->{listPrivate} && !$package->isPublic();

		$inWriter->startTag('item');
		my $name = $package->{name};
		my $uri = $package->getUri();
		my $tocUri = "toc-package-$uri";
		$this->_writeLinkXml($inWriter, $name, $tocUri);
		$inWriter->endTag('item');
    }

	$inWriter->endTag('listGroup');	
	$inWriter->endTag('tocList');
	
    return 1;
}

1;

