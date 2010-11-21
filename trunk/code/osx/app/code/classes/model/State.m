/* See bottom of file for license and copyright information */

#import "State.h"

static BOOL sToolsChecked = NO; // if a check has been done
static BOOL sNeedsInstall = NO;
static BOOL sNeedsUpdate = NO;

@implementation State

+ (BOOL)needsInstall
{
	if (!sToolsChecked) [State _performCheck];
	return sNeedsInstall;
}

+ (BOOL)needsUpdate
{
	if (!sToolsChecked) [State _performCheck];
	return sNeedsUpdate;
}

+ (void)_performCheck
{
	NSDictionary* data = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"VAVDToolsSettingsPath"]];
	if (!data) {
		sNeedsInstall = YES;	
	}
	NSString* toolVersion = [data objectForKey:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"VAVDToolsVersionKey"]];
	if (!toolVersion) {
		sNeedsInstall = YES;
	}
	NSString* desiredVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"VAVDToolsVersion"];
	if (!sNeedsInstall && ![toolVersion isEqualToString:desiredVersion]) {
		sNeedsUpdate = YES;
	}
	sToolsChecked = YES;
}

+ (void)resetCheck
{
	sToolsChecked = NO;
	sNeedsInstall = NO;
	sNeedsUpdate = NO;
}

+ (BOOL)needsToolsInstaller
{
    return [State needsInstall] || [State needsUpdate];
}

@synthesize needsToolsInstaller;

- (BOOL)needsToolsInstaller
{
	return [State needsToolsInstaller];
}

@end

/*
 VisDoc - Code documentation generator, http://visdoc.org
 This software is licensed under the MIT License
 
 The MIT License
 
 Copyright (c) 2010 Arthur Clemens, VisDoc contributors
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

