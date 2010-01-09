#!/bin/sh

LIB_VERSION=$(perl -e "use XML::LibXML; print XML::LibXML->VERSION;")

DESIRED_VERSION='1.69'

echo "Checking version..."
echo "Version $LIB_VERSION"

if [ $LIB_VERSION ] && [ $LIB_VERSION = $DESIRED_VERSION ]; then
	echo "XML::LibXML is up to date, no need to install."
else
	echo "installing module..."
	
	cd /tmp/XML-LibXML/
	tar -xzf "XML-LibXML-1.69.tar.gz"
	cd XML-LibXML-*
	perl Makefile.PL
	make
	sudo make install
fi

# remove
cd /tmp/
rm -rf XML-LibXML

exit 0
