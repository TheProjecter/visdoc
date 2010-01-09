package VisDoc::XMLOutputFormatterAllClassesFrame;
use base 'VisDoc::XMLOutputFormatterListingBase';

use strict;
use XML::Writer;

our $URI = 'allclasses-frame';

=pod

=cut

sub _uri {
    my ($this) = @_;

    return $URI;
}

sub _title {
    my ($this) = @_;

    return $this->_docTerm('all_classes_title');
}

=pod

_writeList( $xmlWriter ) -> $bool

Create a list of classes.
	
=cut

sub _writeList {
    my ( $this, $inWriter ) = @_;
    
    my $classes;
    foreach my $fileData (@{$this->{data}}) {
    	foreach my $package (sort @{$fileData->{packages}}) {
    		next if !$this->{preferences}->{listPrivate} && !$package->isPublic();
    		foreach my $class (@{$package->{classes}}) {
    			next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
    			push @$classes, {class => $class, language => $fileData->{language}};
    		}
    	}
    }
    
    return 0 if (!$classes || !scalar @{$classes});
	
    # sort classes
    @{$classes} =
          sort { lc($a->{class}->{name}) cmp lc($b->{class}->{name}) } @{$classes};
 
 	$inWriter->startTag('tocList');
 	$inWriter->startTag('listGroup');	
          
	foreach my $classHash (sort @{$classes}) {
		my $class = $classHash->{class};
		
		my $summary = $this->getSummaryLine($class->{javadoc}, $class->{fileData});
		
		my $attributes = {
			isPublic => $class->isPublic(),
			isClass => ($class->{type} & $VisDoc::ClassData::TYPE->{CLASS}),
			isInterface => ($class->{type} & $VisDoc::ClassData::TYPE->{INTERFACE}),
			type => $class->{type},
			language => $classHash->{language},
			access => $class->{access},
			summary => $summary,
		};
		$this->_writeClassItem($inWriter, $class->{name}, $class->getUri(), $attributes);
	}
	
	$inWriter->endTag('listGroup');
 	$inWriter->endTag('tocList');
	return 1;
}

1;

