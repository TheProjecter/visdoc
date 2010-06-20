package VisDoc::Defaults;

use strict;
use warnings;

our $FILE_DOCTERMS        = 'templates/lang/docterms.json';
our $FILE_JAVADOCTERMS    = 'templates/lang/javadocterms.json';

our $FILE_CSS_DESTINATION = 'css/VisDoc.css';
our $FILE_JS_DESTINATION  = 'js/';

our $NOT_IMPLEMENTED = 'Not implemented by subclass!';

our $SETTINGS = {
    copyCSS                           => 1,
    copyright                         => 0,
    copyrightText                     => '',
    eventHandlerPrefixes              => 'on,allow',
    eventHandlers                     => 1,
    extensions                        => 'as,java',
    generateIndex                     => 0,
    ignoreClasses                     => '',
    includeSourceCode                 => 0,
    indexTitle                        => 'Documentation',
    listPrivate                       => 0,
    log                               => '',
    openInBrowser                     => 0,
    output                            => '',
    preserveLinebreaks                => 1,
    saveXML                           => 0,
    sidebarWidth                      => '25%',
    templateCss                       => 'VisDoc.css',
    templateCssDirectory              => 'templates/css',
    templateJsDirectory                        => 'templates/js/VisDoc.js',
    templateXslDirectory              => 'templates/xslt',
    templateXslForClasses             => 'VisDoc.xsl',
    templateXslForIndexFrameset       => 'VisDoc_index_frameset.xsl',
    templateXslForPackagesFrameset    => 'VisDoc_packages_frameset.xsl',
    templateXslForPackagesTocFrameset => 'VisDoc_packages_toc_frameset.xsl',
};

1;

# VisDoc - Code documentation generator, http://visdoc.org
# This software is licensed under the MIT License
#
# The MIT License
#
# Copyright (c) 2010 Arthur Clemens, VisDoc contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
