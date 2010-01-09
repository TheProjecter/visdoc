package VisDoc::XMLOutputFormatterOverviewTree;
use base 'VisDoc::XMLOutputFormatterListingBase';

use strict;
use XML::Writer;

our $URI = 'overview-tree';

=pod

=cut

sub _uri {
    my ($this) = @_;

    return $URI;
}

sub _title {
    my ($this) = @_;

    return $this->_docTerm('tree_title');
}

=pod

_writeList( $xmlWriter ) -> $bool

Create a list of:

package A
	class
	class
package B
	class
	class
	
=cut

sub _writeList {
    my ( $this, $inWriter ) = @_;
    
    my $packages;
    my $languages; # store the language of each class to pass with the class attributes later on
    foreach my $fileData (@{$this->{data}}) {
		foreach my $package (sort @{$fileData->{packages}}) {
			next if !$this->{preferences}->{listPrivate} && !$package->isPublic();
			push @{$packages}, $package;
			$languages->{$package->{name}} = $fileData->{language};
		}
	}

    return 0 if (!$packages || !scalar @{$packages});
    
    # sort packages by name
    #@{$packages} = sort { $a->{name} cmp $b->{name} } @{$packages};
 
 	$inWriter->startTag('tocList');
 	$inWriter->startTag('listGroup');	
		
	foreach my $package (sort @{$packages}) {
	
		if ($package->{name}) {
			$inWriter->startTag('item');
			$this->_writeLinkXml($inWriter, $package->{name}, $package->getUri());
			$inWriter->cdataElement('package', 'true');
			$inWriter->endTag('item');
		}
		
		my $classes = $package->{classes};
		# sort classes
    	@{$classes} =
          sort { lc($a->getClasspathWithoutName() || $a->{name}) cmp lc($b->getClasspathWithoutName() || $b->{name}) } @{$classes};
          
		foreach my $class (@{$classes}) {
    	    next if $class->isExcluded();
            next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
			my $classpath = $class->getClasspathWithoutName();
			$classpath .= '.' if $classpath;
			my $attributes = {
				path => $classpath,
				isPublic => $class->isPublic(),
				isClass => ($class->{type} & $VisDoc::ClassData::TYPE->{CLASS}),
				isInterface => ($class->{type} & $VisDoc::ClassData::TYPE->{INTERFACE}),
				type => $class->{type},
				language => $languages->{$package->{name}},
				access => $class->{access},
			};
        	$this->_writeClassItem($inWriter, $class->{name}, $class->getUri(), $attributes);
		}
		
	}
	
	$inWriter->endTag('listGroup');
 	$inWriter->endTag('tocList');
	return 1;
}

1;

