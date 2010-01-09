#!/bin/sh

LIB_VERSION=$(perl -e "use XML::LibXML::Common; print XML::LibXML::Common->VERSION;")

DESIRED_VERSION='0.13'

echo "Checking version..."
echo "Version $LIB_VERSION"

if [ $LIB_VERSION ] && [ $LIB_VERSION = $DESIRED_VERSION ]; then
	echo "XML::LibXML::Common is up to date, no need to install."
else
	echo "installing module..."
	
	cd /tmp/XML-LibXML-Common/
	tar -xzf "XML-LibXML-Common-0.13.tar.gz"
	cd XML-LibXML-Common*
	perl Makefile.PL
	make
	sudo make install
fi

# remove
cd /tmp/
rm -rf XML-LibXML-Common

exit 0
