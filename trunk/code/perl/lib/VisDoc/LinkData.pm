package VisDoc::LinkData;

use base 'VisDoc::FieldData';
use strict;
use warnings;
use VisDoc::StringUtils;

use overload ( '""' => \&as_string );

=pod

StaticMethod createLinkData ($fieldName, $value, $stub ) -> $linkData

=cut

sub createLinkData {
    my ( $inFieldName, $inValue, $inStub ) = @_;

    my $pattern = VisDoc::StringUtils::stripCommentsFromRegex(
        $VisDoc::StringUtils::PATTERN_TAG_PACKAGE_CLASS_METHOD_LABEL);

    $inValue =~ m/$pattern/s;
    my $packageName = $3 || undef;
    my $className   = $4 || undef;
    my $memberName  = $5 || undef;
    my $params      = $6 || undef;
    my $label       = $7 || undef;

    # remove quotes from label at start and end
    $label =~ s/^\"(.*?)\"$/$1/ if $label;

    return VisDoc::LinkData->new(
        $inFieldName, $inStub, $packageName, $className,
        $memberName,  $params, $label
    );
}

=pod

=cut

sub new {
    my ( $class, $inName, $inStub, $inPackageName, $inClassName, $inMemberName,
        $inParams, $inLabel )
      = @_;

    my VisDoc::LinkData $this = $class->SUPER::new($inName);

    $this->{stub}    = $inStub;           # string
    $this->{package} = $inPackageName;    # string
    $this->{class}   = $inClassName;      # string
    $this->{member}  = $inMemberName;     # string
    $this->{params}  = $inParams;         # string
    $this->{label}   = $inLabel;          # string

    $this->{isValidRef} = undef;          # bool -- necessary to keep?
    $this->{isPublic}   = 1;              # bool
    $this->{uri}        = undef;          # string

    # not used in this subclass:
    delete $this->{value};

    bless $this, $class;
    return $this;
}

=pod

=cut

sub getValue {
    my ($this) = @_;

    return $this->{uri};
}

=pod

formatInlineLink( $documentType ) -> $html

Formats data to an inline link: <a href="...">...</a>

=cut

sub formatInlineLink {
    my ( $this, $inDocumentType ) = @_;

    my $label = $this->{label} || '';

    my $classStr = $this->{isPublic} ? '' : " class=\"private\"";
    my $link = '';

    if ( $this->{uri} ) {
        my $type = $inDocumentType || 'html';

        # add document type before the anchor link
        my $url = $this->{uri};
        $url =~ s/(.*?)(#\w+|$)/$1.html$2/;
        $link = "<a href=\"$url\"$classStr>$label</a>";
    }
    else {
        #$label = "$this->{member} $label"  if $this->{member};
        #$label = "$this->{package}.$label" if $this->{package};

        #if ( $this->{member} || $this->{class} || $this->{package} ) {
        #    $link = "<span class=\"doesNotExist\">$label</span>";
        #}
        #else {
        $link = $label;

        #}
    }
    return $link;
}

sub setUri {
    my ( $this, $inUri ) = @_;

    $this->{uri} = $inUri;
}

=pod

=cut

sub as_string {
    my ($this) = @_;

    my $str = 'LinkData:';
    $str .= "\n\t name=$this->{name}"       if defined $this->{name};
    $str .= "\n\t uri=$this->{uri}"         if defined $this->{uri};
    $str .= "\n\t stub=$this->{stub}"       if defined $this->{stub};
    $str .= "\n\t package=$this->{package}" if defined $this->{package};
    $str .= "\n\t class=$this->{class}"     if defined $this->{class};
    $str .= "\n\t member=$this->{member}"   if defined $this->{member};
    $str .= "\n\t params=$this->{params}"   if defined $this->{params};
    $str .= "\n\t label=$this->{label}"     if defined $this->{label};
    $str .= "\n\t comment=$this->{comment}" if defined $this->{comment};
    $str .= "\n\t isValidRef=$this->{isValidRef}"
      if defined $this->{isValidRef};
    $str .= "\n\t isPublic=$this->{isPublic}" if defined $this->{isPublic};
    $str .= "\n";
    return $str;
}

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
