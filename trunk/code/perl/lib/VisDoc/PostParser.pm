package VisDoc::PostParser;

use strict;
use VisDoc::JavadocData;

=pod

process ( \@collectiveFileData ) -> \@collectiveFileData

Processes FileData objects.

=cut

sub process {
    my ($inCollectiveFileData) = @_;

    my $collectiveFileData = _mergePackages($inCollectiveFileData);
    
    # create list of classes
    my $classes = _createListOfClasses($collectiveFileData);
    
    _resolveClasspaths($classes);
    $classes = _removeDuplicates($classes);
    _createListOfImplementedBy($classes);
    _mapSuperclasses($classes);
    _mapInnerclasses($classes);
    _createMemberNameIds($collectiveFileData);
    _copyMethodSendsFieldsToClass($classes);
    _createListOfDispatchedBy($classes);
    _createOverrideEntries($classes);
    _createLinkReferencesInMemberDefinitions($collectiveFileData, $classes);
    _validateLinks($collectiveFileData, $classes);

    #use Data::Dumper;
    #print("collectiveFileData=" . Dumper($collectiveFileData));

    return $collectiveFileData;
}

=pod

Store packages with same language and name in one list
The hash stores lists with each key 'language_packagename'

=cut

sub _mergePackages {
    my ($inCollectiveFileData) = @_;
    
    my %packages = ();
    foreach my $fileData ( @{$inCollectiveFileData} ) {
        foreach my $package ( @{ $fileData->{packages} } ) {
            my $key = "$fileData->{language}";
            $key .= "_$package->{name}" if $package->{name};
            if ( !$packages{$key} ) {
                $packages{$key} = ();
            }
            else {

                # we are adding a package for the second time, so delete
                $fileData->{_markedForDeletion} = 1;
            }
            push( @{ $packages{$key} }, $package );
        }
    }

    # go through the list of packages
    foreach my $key ( keys %packages ) {

        # no need to merge if only 1 package in list
        next if scalar @{ $packages{$key} } < 2;

        # take the first package, use this as base
        my $basePackage = shift @{ $packages{$key} };

        while ( @{ $packages{$key} } ) {
            my $otherPackage = pop @{ $packages{$key} };

            # merge classes (array)
            map { push( @{ $basePackage->{classes} }, $_ ); }
              @{ $otherPackage->{classes} };
            undef $otherPackage->{classes};
            delete $otherPackage->{classes};

            # merge functions (array)
            map { push( @{ $basePackage->{functions} }, $_ ); }
              @{ $otherPackage->{functions} };
            undef $otherPackage->{functions};
            delete $otherPackage->{functions};

            # merge javadoc
            # check if one is present, otherwise we cannot do a merge
            if (   defined $basePackage->{javadoc}
                && defined $otherPackage->{javadoc} )
            {
                $basePackage->{javadoc}->merge( $otherPackage->{javadoc} );
                undef $otherPackage->{javadoc};
                delete $otherPackage->{javadoc};
            }
            elsif ( defined $basePackage->{javadoc}
                && !defined $otherPackage->{javadoc} )
            {

                # do nothing
            }
            elsif ( !defined $basePackage->{javadoc}
                && defined $otherPackage->{javadoc} )
            {
                $basePackage->{javadoc} = $otherPackage->{javadoc};
                undef $otherPackage->{javadoc};
                delete $otherPackage->{javadoc};
            }

            undef $otherPackage;
        }
    }

    # remove items
	my $cleanCollectiveFileData;
    foreach my $fileData ( @{$inCollectiveFileData} ) {
    	if (!$fileData->{_markedForDeletion}) {
        	push(@{$cleanCollectiveFileData}, $fileData);
        }
    }
    return $cleanCollectiveFileData;
}

=pod

=cut

sub _createListOfClasses {
    my ($inCollectiveFileData) = @_;

	my $list;
	foreach my $fileData ( @{$inCollectiveFileData} ) {
        foreach my $package ( @{ $fileData->{packages} } ) {
            foreach my $class ( @{ $package->{classes} } ) {
            	push @{$list}, $class;
            }
        }
    }
    return $list;
}

=pod

Sets the classpaths for superclasses and interfaces that do not have one yet.
That means they are probably within the same package.
We will check this, and if so, set the classpath accordingly.

We need to resolve the classpaths to be able to create an inheritance chain, in ClassData::getSuperclassChain.

=cut

sub _resolveClasspaths {
    my ($inClasses) = @_;

	foreach my $class ( @{ $inClasses } ) {
		foreach my $superclass ( @{ $class->{superclasses} } ) {
			my $correspondingClass =
			  _getClassWithName( $inClasses,
				$superclass->{name}, $class->{packageName} );

			if ($correspondingClass) {
				$superclass->{classpath} =
				  $correspondingClass->{classpath};
				$superclass->{classdata} = $correspondingClass;
			}
		}
		foreach my $interface ( @{ $class->{interfaces} } ) {
			my $correspondingClass =
			  _getClassWithName( $inClasses,
				$interface->{name}, $class->{packageName} );
			if ($correspondingClass) {
				$interface->{classpath} =
				  $correspondingClass->{classpath};
				$interface->{classdata} = $correspondingClass;
			}
		}
	}
}

=pod

StaticMethod _getClassWithName( \@classes ) -> \@classData

Finds ClassData objects with duplicate classpaths. If found, retains the newest class only.

=cut

sub _removeDuplicates {
    my ($inClasses) = @_;

	my $classRefs = {};
	foreach my $class ( @{ $inClasses } ) {
		my $classpath = $class->{classpath};
		$classRefs->{$classpath}->{count}++;
		# store class for retrieval
		push @{$classRefs->{$classpath}->{classes}}, $class;
	}
	
	my @unique;
    while ( my ($classpath, $value) = each(%$classRefs) ) {
    	my $duplicateClasses = $classRefs->{$classpath}->{classes};
    	# reverse sort by modification date (latest first)
    	@{$duplicateClasses} = sort { $b->{fileData}->{modificationDate} <=> $a->{fileData}->{modificationDate} } @{$duplicateClasses};
    	push @unique, $classRefs->{$classpath}->{classes}->[0];
 	}
 	return \@unique;
}

=pod

StaticMethod _getClassWithName( $classes, $name, $packageName ) -> $classData

Finds the ClassData object with name $name.
Optionally pass $packageName if the package name should match as well.

=cut

sub _getClassWithName {
    my ( $inClasses, $inName, $inPackageName ) = @_;
	
	return if !$inName;
	foreach my $class ( @{ $inClasses } ) {
		if ($inPackageName) {
			return $class
			  if ( ( $class->{name} eq $inName )
				&& ( $class->{packageName} eq $inPackageName ) );
		}
		else {
			if ( $class->{name} && ($class->{name} eq $inName)) {
				return $class;
			}
		}
	}

    # not found
    return undef;
}

=pod
sub _findClassWithClasspath {
    my ( $inCollectiveFileData, $inClasspath ) = @_;

    foreach my $fileData ( @{$inCollectiveFileData} ) {
        foreach my $package ( @{ $fileData->{packages} } ) {
            foreach my $class ( @{ $package->{classes} } ) {
                if (   ( defined $class->{classpath} )
                    && ( $class->{classpath} eq $inClasspath ) )
                {
                    return $class;
                }
            }
        }
    }
    return undef;
}
=cut

=pod

For each class=>interface, sets {implementedBy} at each class.

=cut

sub _createListOfImplementedBy {
    my ($inClasses) = @_;

	foreach my $class ( @{ $inClasses } ) {
		foreach my $interface ( @{ $class->{interfaces} } ) {
			if ( $interface->{classdata} ) {
				push(
					@{ $interface->{classdata}->{implementedBy} },
					$class
				);
			}
		}
	}
}

=pod

Adds a follow number to member names that have the same name, and stores the unique name with $MemberData->setNameId()

=cut

sub _createMemberNameIds {
    my ($inCollectiveFileData) = @_;

	foreach my $fileData ( @{$inCollectiveFileData} ) {

        foreach my $package ( @{ $fileData->{packages} } ) {

            my %seen = ();
			foreach my $member ( @{ $package->{functions} } ) {
				my $name = $member->{name};
				my $nameId = $name;
				$nameId .= $seen{$name} if $seen{$name};
				$member->setNameId($nameId);
				$seen{$name}++;
			}
			
            foreach my $class ( @{ $package->{classes} } ) {
                        
				my %seen = ();
				foreach my $member ( @{ $class->getMembers() } ) {
					my $name = $member->{name};
					my $nameId = $name;
					$nameId .= $seen{$name} if $seen{$name};
					$member->setNameId($nameId);
					$seen{$name}++;
				}
			}
		}
	}
}

=pod

Copies @sends tags FieldData objects to the class javadoc.

=cut

sub _copyMethodSendsFieldsToClass {
    my ($inClasses) = @_;

	foreach my $class ( @{$inClasses} ) {
		foreach my $member ( @{ $class->getMembers() } ) {
			if ( $member->{javadoc} ) {
				my $sendsFields =
				  $member->{javadoc}->fieldsWithName('sends');

				# create javadoc object if it does not exist yet
				if ( $sendsFields && !$class->{javadoc} ) {
					$class->{javadoc} = VisDoc::JavadocData->new();
				}
				foreach my $fieldData ( @{$sendsFields} ) {
					push( @{ $class->{javadoc}->{fields} },
						$fieldData );
				}
			}
		}
	}
}

=pod

=cut

sub _createListOfDispatchedBy {
    my ($inClasses) = @_;

	foreach my $class ( @{ $inClasses } ) {
		if ( $class->{javadoc} ) {
			my $sendsFields =
			  $class->{javadoc}->fieldsWithName('sends');
			foreach my $fieldData ( @{$sendsFields} ) {
				my $className = $fieldData->{class};
				if ($className) {
					my $classRef =
					  _getClassWithName( $inClasses,
						$className );
					if ($classRef) {
						push( @{ $classRef->{dispatchedBy} }, $class );
					}
				}
			}
		}
	}
}

=pod

Adds field 'overrides' to member javadoc if member->overrides() is true.

=cut

sub _createOverrideEntries {
    my ( $inClasses ) = @_;
        
    foreach my $class ( @{ $inClasses } ) {
    	foreach my $superclass ( @{ $class->{superclasses} } ) {
    		foreach my $member ( @{ $class->getMembers() } ) {
				
				if ($member->overrides()) {
					my $javadoc = $member->{javadoc};
					$member->{javadoc} = VisDoc::JavadocData->new() if !$javadoc;
					
					my $linkField = VisDoc::LinkData::createLinkData('overrides', '#' . $member->{name});
					$linkField->{class} = $superclass->{name};

					push @{$member->{javadoc}->{fields}}, $linkField;
				}				
			}
		}
    }
}

=pod

For each class=>superclass, sets {subclasses} at each class.

=cut

sub _mapSuperclasses {
    my ($inClasses) = @_;

	foreach my $class ( @{ $inClasses } ) {
		foreach my $superclass ( @{ $class->{superclasses} } ) {
			if ( $superclass->{classdata} ) {
				push(
					@{ $superclass->{classdata}->{subclasses} },
					$class
				);
			}
		}
	}
}

=pod

For each class=>innerclasses, sets {isInnerClass} to 1.

=cut

sub _mapInnerclasses {
    my ($inClasses) = @_;

	foreach my $class ( @{ $inClasses } ) {
		foreach my $innerClass ( @{ $class->{innerClasses} } ) {
#			if ( $innerClass->{classdata} ) {
				$innerClass->{isInnerClass} = 1;
#			}
		}
	}
}

sub _createLinkReferencesInMemberDefinitions {
    my ($inCollectiveFileData, $inClasses) = @_;

    foreach my $fileData ( @{$inCollectiveFileData} ) {
    	$fileData->createLinkReferencesInMemberDefinitions($inClasses);
    }
}

=pod

Checks for each LinkData object if the referencing class or method is valid or private.

=cut

sub _validateLinks {
    my ($inCollectiveFileData, $inClasses) = @_;

    my $package, my $class, my $member;

    foreach my $fileData ( @{$inCollectiveFileData} ) {

        foreach $package ( @{ $fileData->{packages} } ) {

            # package javadoc
            _validateLinkData( $inClasses,
                $package->{javadoc}->getLinkDataFields(),
                $package, $class, $member )
              if $package->{javadoc};

            foreach $class ( @{ $package->{classes} } ) {

                # class javadoc
                _validateLinkData( $inClasses,
                    $class->{javadoc}->getLinkDataFields(),
                    $package, $class, $member )
                  if $class->{javadoc};

                foreach $member ( @{ $class->getMembers() } ) {

                    # member javadoc
                    _validateLinkData( $inClasses,
                        $member->{javadoc}->getLinkDataFields(),
                        $package, $class, $member )
                      if $member->{javadoc};
                }
            }
        }
        
        # parse inline links stored in FileData {linkDataRefs}
        my $fields;
        while (my ( $key, $linkData) = each %{$VisDoc::FileData::linkDataRefs } ) {
        	push @{$fields}, $$linkData;
        }
        _validateLinkData( $inClasses, $fields ) if $fields;
    }
}

=pod

Finds class and member references for LinkData {class} and {member} properties:
- sets the URI for the LinkData objects
- if no URI can be created, sets isValid=0
- copies isPrivate property from class and members

=cut

sub _validateLinkData {
    my ( $inClasses, $inFields, $inPackage, $inClass, $inMember ) =
      @_;

    return if !$inFields;

    foreach my $link ( @{$inFields} ) {
		
        my $className = $link->{class} || $inClass->{name};
                
        my $classRef =
          _getClassWithName( $inClasses, $className );
		my $member = $classRef->getMemberWithName( $link->{member} ) if ( $classRef && $link->{member} );
				
        # set URI
        my $memberName;
        if ($member) {
        	$memberName = $member->{nameId};
		}
        my $uri = $classRef->getUri( $memberName ) if $classRef;
        if ($uri) {
            $link->setUri($uri);
            $link->{isValidRef} = 1;
        }
        else {
            $link->{isValidRef} = 0;
        }

        # set isPublic
        if ( $classRef && !$link->{member} ) {
            $link->{isPublic} = $classRef->isPublic();
        }
        $link->{isPublic} = $member->isPublic() if $member;

        # set label
        if ( !$link->{label} ) {

            # if label not specified, create a new one
            # 3 cases according to the specs:
            # 	1: same class, same package: use member only
            #	2: different class, same package: use class.member
            # 	3: different class, different package: use package.class.member
            my @labelComponents = ();
            push( @labelComponents, $link->{package} ) if $link->{package};
            push( @labelComponents, $link->{class} )   if $link->{class};
            push( @labelComponents, $link->{member} )  if $link->{member};
            $link->{label} = join( '.', @labelComponents );
        }
    }
}

1;
