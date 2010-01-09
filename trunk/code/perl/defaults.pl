#! /usr/bin/perl -w

use strict;
#use warnings;
use Cwd 'getcwd';
use Getopt::Long;
use Pod::Usage;

BEGIN {
    my $root = Cwd::abs_path;
    unshift @INC, "$root/lib/CPAN/lib";
    unshift @INC, "$root/lib";
}

# check if we can read the right modules
eval "use VisDoc::Defaults";
if ($@) {
    print STDOUT $@;
    die;
}

# check if we can read the right module
eval "use VisDoc::CocoaUtils";
if ($@) {
	print STDOUT $@;
	die;
}

my $propertyListString =
  VisDoc::CocoaUtils::createPropertyListFromData($VisDoc::Defaults::SETTINGS);
print STDOUT $propertyListString;

1;
