package VisDoc::PackageData;

use strict;
use VisDoc::StringUtils;

our $MEMBER_TYPE = {
    CLASS               => ( 1 << 1 ),
    FUNCTION            => ( 1 << 2 ),
};

=pod

StaticMethod createUriForPackage( $name ) -> $text

Creates a safe filename string derived from $name.

=cut

sub createUriForPackage {
    my ($inName) = @_;
    
    my $uri = "package-$inName";
    VisDoc::StringUtils::trimSpaces($uri);
    
    # change dots and spaces to underscores
    $uri =~ s/[\. ]/_/go;

    return $uri;
}

=pod

=cut

sub new {
    my ($class) = @_;
    my $this = {
    	fileData  => undef,    # ref of FileData object; set by FileParser
        name      => undef,
        anonymous => 0,        # is anonymous package: true (1) or false (0)
        access    => undef,    # ref of list of access, not used
        classes   => undef,
        functions => undef,    # ref of list of MethodData objects
        javadoc   => undef,    # JavaDoc object
    };
    bless $this, $class;
    return $this;
}

=pod

getUri() -> $text

Creates a safe filename string derived from the name. Calls createUriForPackage.

=cut

sub getUri {
    my ($this) = @_;

    return createUriForPackage( $this->{name} );
}

=cut

=pod

getMemberCount ($listPrivate, $memberType) -> $int

Counts all classes and functions of the package.

param $listPrivate: 

=cut

sub getMemberCount {
    my ($this, $listPrivate, $memberType) = @_;

	$memberType |= ($MEMBER_TYPE->{CLASS} | $MEMBER_TYPE->{FUNCTION});

    my $count = 0;
    if ($listPrivate) {
	    $count += scalar @{ $this->{classes} }   if $this->{classes} && ($memberType & $MEMBER_TYPE->{CLASS});
    	$count += scalar @{ $this->{functions} } if $this->{functions} && ($memberType & $MEMBER_TYPE->{FUNCTION});
	} else {
	
		my $mem;
		if ($this->{classes} && ($memberType & $MEMBER_TYPE->{CLASS})) {
			foreach my $mem (@{ $this->{classes} }) {
				$count++ if $mem->isPublic();
			}
		}
		if ($this->{functions} && ($memberType & $MEMBER_TYPE->{FUNCTION})) {
			foreach my $mem (@{ $this->{functions} }) {
				$count++ if $mem->isPublic();
			}
		}
	}
	
    return $count;
}

sub getClasses {
    my ($this) = @_;

	return $this->{classes};
}

sub getFunctions {
    my ($this) = @_;

	return $this->{functions};
}

sub isExcluded {
    my ($this) = @_;

	return 1
      if $this->{javadoc}
          && $this->{javadoc}->getSingleFieldWithName('exclude')
    ;    # overrides class access
    
    return 0;
}

=pod

isPublic() -> $bool

The class is public if javadoc does not have a field 'private', and if access is public.

=cut

sub isPublic {
    my ($this) = @_;

    return 1;
}

1;
