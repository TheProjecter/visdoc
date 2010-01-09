package VisDoc::XMLOutputFormatterPackageToc;
use base 'VisDoc::XMLOutputFormatterTocBase';

use strict;
use XML::Writer;

=pod

=cut

sub _uri {
    my ($this) = @_;

	my $uri = $this->{data}->getUri();
	my $tocUri = "toc-package-$uri";
    return $tocUri;
}

=pod

=cut

sub _writeTitleAndPageId {
    my ( $this, $inWriter ) = @_;

	my $title = $this->_docTerm('classproperty_package');
    $inWriter->cdataElement( 'title', $title );
    my $uri = $this->{data}->getUri();
    $this->_writeLinkXml($inWriter, $this->{data}->{name}, $uri);
}

=pod

_writeListData ($xmlWriter, $classData) -> $bool

=cut

sub _writeListData {
    my ( $this, $inWriter ) = @_;
    
    $inWriter->startTag('tocList');
    
	my $classes;
    foreach my $class (@{$this->{data}->{classes}}) {
    	next if $class->isExcluded();
		next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
		push (@$classes, $class) if ($class->{type} & $VisDoc::ClassData::TYPE->{'CLASS'});
    }
    
    my $interfaces;
    foreach my $class (@{$this->{data}->{classes}}) {
    	next if $class->isExcluded();
		next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
		push (@$interfaces, $class) if ($class->{type} & $VisDoc::ClassData::TYPE->{'INTERFACE'});
    }
    
    my $functions;
    foreach my $function (@{$this->{data}->{functions}}) {
    	next if $function->isExcluded();
		next if !$this->{preferences}->{listPrivate} && !$function->isPublic();
		push (@$functions, $function);
    }
    
	# classes
	if ($classes && scalar @$classes) {
	
		$inWriter->startTag('listGroup');	
		$inWriter->cdataElement('listGroupTitle', $this->_docTerm('summary_classes'));
		foreach my $class (@{$classes}) {
			my $attributes = {
				isClass => 1,
				isPublic => $class->isPublic(),
				type => $class->{type},
				access => $class->{access},
			};
			$this->_writeClassItem($inWriter, $class->{name}, $class->getUri(), $attributes);
		}
		$inWriter->endTag('listGroup');	
	}
	
	# interfaces
	if ($interfaces && scalar @$interfaces) {
	
		$inWriter->startTag('listGroup');	
		$inWriter->cdataElement('listGroupTitle', $this->_docTerm('summary_interfaces'));
		foreach my $interface (@{$interfaces}) {
			my $attributes = {
				isInterface => 1,
				isPublic => $interface->isPublic(),
				type => $interface->{type},
				access => $interface->{access},
			};
			$this->_writeClassItem($inWriter, $interface->{name}, $interface->getUri(), $attributes);
		}
		$inWriter->endTag('listGroup');	
	}
	
	# functions
	if ($functions && scalar @$functions) {
	
		$inWriter->startTag('listGroup');	
		$inWriter->cdataElement('listGroupTitle', $this->_docTerm('summary_functions'));
		foreach my $function (@{$functions}) {
			my $uri = VisDoc::PackageData::createUriForPackage($this->{data}->{name}, $function->{name});
						
			my $attributes = {
				isMethod => 1,
				isPublic => $function->isPublic(),
				memberName => $function->{name},
				type => $function->{type},
				access => $function->{access},
			};
			$this->_writeClassItem($inWriter, $function->{name}, $uri, $attributes);
		}
		$inWriter->endTag('listGroup');	
	}
	
	$inWriter->endTag('tocList');
	
    return 1;
}
1;

