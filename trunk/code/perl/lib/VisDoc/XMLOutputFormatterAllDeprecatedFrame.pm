package VisDoc::XMLOutputFormatterAllDeprecatedFrame;
use base 'VisDoc::XMLOutputFormatterListingBase';

use strict;
use XML::Writer;

our $URI = 'alldeprecated-frame';

=pod

=cut

sub _uri {
    my ($this) = @_;

    return $URI;
}

sub _title {
    my ($this) = @_;

    return $this->_docTerm('all_deprecated_title');
}

=pod

_writeList( $xmlWriter ) -> $bool

Create a list of classes.
	
=cut

sub _writeList {
    my ( $this, $inWriter ) = @_;
    
    my $hasFormattedDataCount = 0;
    
    $inWriter->startTag('tocList');
    
    $hasFormattedDataCount += $this->_deprecatedPackages($inWriter);
    $hasFormattedDataCount += $this->_deprecatedClasses($inWriter);
    $hasFormattedDataCount += $this->_deprecatedInterfaces($inWriter);
    $hasFormattedDataCount += $this->_deprecatedMethods($inWriter);
    $hasFormattedDataCount += $this->_deprecatedProperties($inWriter);
 	
 	$inWriter->endTag('tocList');
 	
	return ($hasFormattedDataCount > 0);
}

=pod

=cut

sub _deprecatedPackages {
    my ( $this, $inWriter ) = @_;
    
    my $deprecated;
    foreach my $fileData (@{$this->{data}}) {
    	foreach my $package (@{$fileData->{packages}}) {
    		my $deprecatedFields = $package->{javadoc}->fieldsWithName('deprecated') if $package->{javadoc};
    		next if !$deprecatedFields;
    		next if !$this->{preferences}->{listPrivate} && !$package->isPublic();
    		push @{$deprecated}, { obj => $package, language => $fileData->{language}, fileData => $fileData }; 
    	}
    }
    return 0 if (!$deprecated || !scalar @{$deprecated});
    
    # sort classes
    @{$deprecated} =
          sort { lc($a->{obj}->{name}) cmp lc($b->{obj}->{name}) } @{$deprecated};
    $this->_writeGroup($inWriter, $deprecated, 'deprecated_packages');
    
    return 1;
}

=pod

=cut

sub _deprecatedClasses {
    my ( $this, $inWriter ) = @_;
    
	return $this->_deprecatedClassesOrInterfaces($inWriter, 'CLASS', 'deprecated_classes');
}

=pod

=cut

sub _deprecatedInterfaces {
    my ( $this, $inWriter ) = @_;
    
	return $this->_deprecatedClassesOrInterfaces($inWriter, 'INTERFACE', 'deprecated_interfaces');
}
   
=pod

=cut

sub _deprecatedClassesOrInterfaces {
    my ( $this, $inWriter, $inClassType, $inDocKey ) = @_;
    
    my $deprecated;
    foreach my $fileData (@{$this->{data}}) {
    	foreach my $package (@{$fileData->{packages}}) {
    		next if !$this->{preferences}->{listPrivate} && !$package->isPublic();
    		foreach my $class (@{$package->{classes}}) {
    			next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
				my $deprecatedFields = $class->{javadoc}->fieldsWithName('deprecated') if $class->{javadoc};
				next if !$deprecatedFields;
				next if !($class->{type} & $VisDoc::ClassData::TYPE->{$inClassType});
				push @{$deprecated}, { obj => $class, language => $fileData->{language}, fileData => $fileData };
			}
    	}
    }
    
    return 0 if (!$deprecated || !scalar @{$deprecated});
    
    # sort classes
    @{$deprecated} =
          sort { lc($a->{obj}->{name}) cmp lc($b->{obj}->{name}) } @{$deprecated};
    $this->_writeGroup($inWriter, $deprecated, $inDocKey);
    
    return 1;
}

=pod

=cut

sub _deprecatedMethods {
    my ( $this, $inWriter ) = @_;
    
    my $deprecated;
    foreach my $fileData (@{$this->{data}}) {
    	foreach my $package (@{$fileData->{packages}}) {
    		next if !$this->{preferences}->{listPrivate} && !$package->isPublic();
    		foreach my $function (@{$package->{functions}}) {
    			next if !$this->{preferences}->{listPrivate} && !$function->isPublic();
    			my $deprecatedFields = $function->{javadoc}->fieldsWithName('deprecated') if $function->{javadoc};
				next if !$deprecatedFields;
				
    			my $methodId = $function->getId() . ".$package->{name}";
    			push @$deprecated, {id => $methodId, obj => $function, language => $fileData->{language}, fileData => $fileData, owner => $package};
    		}
    		foreach my $class (@{$package->{classes}}) {
    			next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
    			foreach my $method (@{$class->{methods}}) {
    				next if !$this->{preferences}->{listPrivate} && !$method->isPublic();
					my $deprecatedFields = $method->{javadoc}->fieldsWithName('deprecated') if $method->{javadoc};
					next if !$deprecatedFields;
					my $methodId = $method->getId() . ".$class->{name}.$package->{name}";
					push @{$deprecated}, { obj => $method, id => $methodId, language => $fileData->{language}, owner => $class, fileData => $fileData };
				}
			}
    	}
    }
    
    return 0 if (!$deprecated || !scalar @{$deprecated});
    
    # sort methods
    @{$deprecated} =
          sort { lc($a->{id}) cmp lc($b->{id}) } @{$deprecated};
          
	# find duplicate member names and add class names
 	my $refCounts;
 	foreach my $methodHash (@{$deprecated}) {
		my $name = $methodHash->{obj}->{name};
		$refCounts->{$name}->{count}++;
		push @{$refCounts->{$name}->{methods}}, $methodHash;
	}
    while ( my ($key, $value) = each(%$refCounts) ) {
    	next if $refCounts->{$key}->{count} < 2;
    	foreach my $methodHash (@{$refCounts->{$key}->{methods}}) {
 			$methodHash->{isDuplicateName} = 1;
    	}
 	}
 	
    $this->_writeGroup($inWriter, $deprecated, 'deprecated_methods');
    
    return 1;
}

=pod

=cut

sub _deprecatedProperties {
    my ( $this, $inWriter ) = @_;
    
    my $deprecated;
    foreach my $fileData (@{$this->{data}}) {
    	foreach my $package (@{$fileData->{packages}}) {
    		next if !$this->{preferences}->{listPrivate} && !$package->isPublic();
    		foreach my $class (@{$package->{classes}}) {
    			next if !$this->{preferences}->{listPrivate} && !$class->isPublic();
    			foreach my $property (@{$class->{properties}}) {
    				next if !$this->{preferences}->{listPrivate} && !$property->isPublic();
					my $deprecatedFields = $property->{javadoc}->fieldsWithName('deprecated') if $property->{javadoc};
					next if !$deprecatedFields;
					my $methodId = $property->getId() . ".$class->{name}.$package->{name}";
					push @{$deprecated}, { obj => $property, id => $methodId, language => $fileData->{language}, owner => $class, fileData => $fileData };
				}
			}
    	}
    }
    
    return 0 if (!$deprecated || !scalar @{$deprecated});
    
    # sort property
    @{$deprecated} =
          sort { lc($a->{id}) cmp lc($b->{id}) } @{$deprecated};
          
	# find duplicate member names and add class names
 	my $refCounts;
 	foreach my $methodHash (@{$deprecated}) {
		my $name = $methodHash->{obj}->{name};
		$refCounts->{$name}->{count}++;
		push @{$refCounts->{$name}->{methods}}, $methodHash;
	}
    while ( my ($key, $value) = each(%$refCounts) ) {
    	next if $refCounts->{$key}->{count} < 2;
    	foreach my $methodHash (@{$refCounts->{$key}->{methods}}) {
 			$methodHash->{isDuplicateName} = 1;
    	}
 	}
 	
    $this->_writeGroup($inWriter, $deprecated, 'deprecated_properties');
    
    return 1;
}

=pod

=cut

sub _writeGroup {
    my ( $this, $inWriter, $inObjectHash, $inDocKey ) = @_;

	$inWriter->startTag('listGroup');
    $inWriter->cdataElement('listGroupTitle', $this->_docTerm($inDocKey));
    
    foreach my $inObjectHash (@{$inObjectHash}) {
    	my $obj = $inObjectHash->{obj};
    	my $name = $obj->{name};
		my $uri = $obj->isa("VisDoc::MemberData") ? $inObjectHash->{owner}->getUri() : $obj->getUri();
		my $summary = $this->getSummaryLine($obj->{javadoc}, $inObjectHash->{fileData});
		
    	my $attributes = {
			isPublic => $obj->isPublic(),
			isClass => $obj->{type} ? ($obj->{type} & $VisDoc::ClassData::TYPE->{CLASS}) : undef,
			isInterface => $obj->{type} ? ($obj->{type} & $VisDoc::ClassData::TYPE->{INTERFACE}) : undef,
			isMethod => $obj->isa("VisDoc::MethodData") ? 1 : 0,
			isProperty => $obj->isa("VisDoc::PropertyData") ? 1 : 0,
			memberName => $obj->{nameId},
			language => $inObjectHash->{language},
			access => $obj->{access},
			type => $obj->{type},
			summary => $summary,
			className => $inObjectHash->{isDuplicateName} ? $inObjectHash->{owner}->{name} : undef,
		};

		$this->_writeClassItem($inWriter, $name, $uri, $attributes);
    }
    
    $inWriter->endTag('listGroup');
}

1;

