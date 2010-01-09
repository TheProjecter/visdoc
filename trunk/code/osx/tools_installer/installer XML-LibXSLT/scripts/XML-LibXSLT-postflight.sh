#!/bin/sh

LIB_VERSION=$(perl -e "use XML::LibXSLT; print XML::LibXSLT->VERSION;")

DESIRED_VERSION='1.68'

echo "Checking version..."
echo "Version $LIB_VERSION"

if [ $LIB_VERSION ] && [ $LIB_VERSION = $DESIRED_VERSION ]; then
	echo "XML::LibXSLT is up to date, no need to install."
else
	echo "installing module..."
	
	cd /tmp/XML-LibXSLT/
	tar -xzf "XML-LibXSLT-1.68.tar.gz"
	cd XML-LibXSLT*
	perl Makefile.PL
	make
	sudo make install
fi

# remove
cd /tmp/
rm -rf XML-LibXSLT

exit 0
