package VisDoc::Defaults;

use strict;

our $FILE_DOCTERMS     = 'templates/lang/docterms.json';
our $FILE_JAVADOCTERMS = 'templates/lang/javadocterms.json';
our $FILE_JS_TEMPLATE_DIR = 'templates/js/';

our $FILE_CSS_DESTINATION  = 'css/VisDoc.css';
our $FILE_JS_DESTINATION  = 'js/';

our $NOT_IMPLEMENTED = 'Not implemented by subclass!';

our $SETTINGS = {
	copyCSS => 1,
	copyright => 0,
	copyrightText => '',
	eventHandlerPrefixes => 'on,allow',
	eventHandlers => 1,
	extensions => 'as,java',
	generateIndex => 0,
	ignoreClasses => '',
	includeSourceCode => 0,
	indexTitle => 'Documentation',
	listPrivate => 0,
	out => '',
	preserveLinebreaks => 1,
	saveXML => 0,
	sidebarWidth => '25%',
	cssTemplateDirectory => 'templates/css',
	cssTemplate => 'VisDoc.css',
	xslTemplateDirectory => 'templates/xslt',
	xslTemplateForClasses => 'VisDoc.xsl',
	xslTemplateForIndexFrameset => 'VisDoc_index_frameset.xsl',
	xslTemplateForPackagesFrameset => 'VisDoc_packages_frameset.xsl',
	xslTemplateForPackagesTocFrameset => 'VisDoc_packages_toc_frameset.xsl',
	log => '',
};

1;
