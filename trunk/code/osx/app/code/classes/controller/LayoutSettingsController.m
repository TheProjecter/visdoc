/* See bottom of file for license and copyright information */

#import "LayoutSettingsController.h"
#import "MyDocument.h"
#import "interfacestrings.h"

@implementation LayoutSettingsController

@synthesize usesDefaults;

- (void)dealloc
{
	[usesDefaults release];
	[super dealloc];
}

- (IBAction)showSettingsWindow:(id)sender
{
	[oSettingsTable reloadData];
	[oSettingsWindow center];
	[oSettingsWindow makeKeyAndOrderFront:self];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return 8;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex
{	
	if ([[aTableColumn identifier] isEqualToString:@"key"]) {
		if (rowIndex == 0) return @"css template directory";
		if (rowIndex == 1) return @"css template";
		if (rowIndex == 2) return @"js template directory";
		if (rowIndex == 3) return @"xsl template directory";
		if (rowIndex == 4) return @"xsl template for classes";
		if (rowIndex == 5) return @"xsl template for index-frameset";
		if (rowIndex == 6) return @"xsl template for packages-frameset";
		if (rowIndex == 7) return @"xsl template for packages-toc-frameset";
	}
	if ([[aTableColumn identifier] isEqualToString:@"value"]) {
		if (rowIndex == 0) return [[delegate settings] objectForKey:@"templateCssDirectory"];
		if (rowIndex == 1) return [[delegate settings] objectForKey:@"templateCss"];
		if (rowIndex == 2) return [[delegate settings] objectForKey:@"templateJsDirectory"];
		if (rowIndex == 3) return [[delegate settings] objectForKey:@"templateXslDirectory"];
		if (rowIndex == 4) return [[delegate settings] objectForKey:@"templateXslForClasses"];
		if (rowIndex == 5) return [[delegate settings] objectForKey:@"templateXslForIndexFrameset"];
		if (rowIndex == 6) return [[delegate settings] objectForKey:@"templateXslForPackagesFrameset"];
		if (rowIndex == 7) return [[delegate settings] objectForKey:@"templateXslForPackagesTocFrameset"];
	}
	return nil;
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	if ([[aTableColumn identifier] isEqualToString:@"value"]) {
		NSString* key;
		if (rowIndex == 0) key = @"templateCssDirectory";
		if (rowIndex == 1) key = @"templateCss";
		if (rowIndex == 2) key = @"templateJsDirectory";
		if (rowIndex == 3) key = @"templateXslDirectory";
		if (rowIndex == 4) key = @"templateXslForClasses";
		if (rowIndex == 5) key = @"templateXslForIndexFrameset";
		if (rowIndex == 6) key = @"templateXslForPackagesFrameset";
		if (rowIndex == 7) key = @"templateXslForPackagesTocFrameset";
		[[delegate settings] setObject:anObject forKey:key];
	}
}

- (IBAction)restoreToDefaultValues:(id)sender
{
	[self setToValues:[delegate defaultSettings]];
}

- (void)setToValues:(NSDictionary*)dictionary
{
	[[delegate settings] setObject:[dictionary objectForKey:@"templateCssDirectory"] forKey:@"templateCssDirectory"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateCss"] forKey:@"templateCss"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateJsDirectory"] forKey:@"templateJsDirectory"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateXslDirectory"] forKey:@"templateXslDirectory"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateXslForClasses"] forKey:@"templateXslForClasses"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateXslForIndexFrameset"] forKey:@"templateXslForIndexFrameset"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateXslForPackagesFrameset"] forKey:@"templateXslForPackagesFrameset"];
	[[delegate settings] setObject:[dictionary objectForKey:@"templateXslForPackagesTocFrameset"] forKey:@"templateXslForPackagesTocFrameset"];
	[oSettingsTable reloadData];
}

- (IBAction)importSettings:(id)sender
{
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setResolvesAliases:YES];
	[openPanel setPrompt:IFACE_SELECT];
	NSArray* validFileExtensions = [NSArray arrayWithObjects:@"plist", nil];
	
    [openPanel beginSheetForDirectory:nil
                                 file:nil
                                types:validFileExtensions
                       modalForWindow:oSettingsWindow
                        modalDelegate:self
                       didEndSelector:@selector(importPanelDidEnd:returnCode:contextInfo:)
                          contextInfo:nil];
}

- (void)importPanelDidEnd:(NSOpenPanel*)sheet
					 returnCode:(int)returnCode
					contextInfo:(void*)contextInfo
{
    if (returnCode == NSOKButton) {
		NSArray* paths = [sheet filenames];
		if (paths != nil) {
			NSDictionary* importSettings = [NSDictionary dictionaryWithContentsOfFile:[paths objectAtIndex:0]];
			if (importSettings) {
				[self setToValues:importSettings];	
			}
		}
	}
}

- (IBAction)exportSettings:(id)sender
{
	NSSavePanel *panel = [NSSavePanel savePanel];
	[panel setRequiredFileType:@"plist"];
	[panel setCanCreateDirectories:YES];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
		BOOL success = [[self settings] writeToFile:[panel filename] atomically:YES];
		if (!success) {
			NSRunAlertPanel(@"Error saving", @"Could not save settings", @"OK", nil, nil);
		}
    }
}

- (NSDictionary*)settings
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[[delegate settings] objectForKey:@"templateCssDirectory"], @"templateCssDirectory",
		[[delegate settings] objectForKey:@"templateCss"], @"templateCss",
		[[delegate settings] objectForKey:@"templateJsDirectory"], @"templateJsDirectory",
		[[delegate settings] objectForKey:@"templateXslDirectory"], @"templateXslDirectory",
		[[delegate settings] objectForKey:@"templateXslForClasses"], @"templateXslForClasses",
		[[delegate settings] objectForKey:@"templateXslForIndexFrameset"], @"templateXslForIndexFrameset",
		[[delegate settings] objectForKey:@"templateXslForPackagesFrameset"], @"templateXslForPackagesFrameset",
		[[delegate settings] objectForKey:@"templateXslForPackagesTocFrameset"], @"templateXslForPackagesTocFrameset",
			nil];
}

- (BOOL)hasDefaultSettings
{
	if (![self compareCurrentWithDefault:@"templateCssDirectory"]) return NO;
	if (![self compareCurrentWithDefault:@"templateCss"]) return NO;
	if (![self compareCurrentWithDefault:@"templateJsDirectory"]) return NO;
	if (![self compareCurrentWithDefault:@"templateXslDirectory"]) return NO;
	if (![self compareCurrentWithDefault:@"templateXslForClasses"]) return NO;
	if (![self compareCurrentWithDefault:@"templateXslForIndexFrameset"]) return NO;
	if (![self compareCurrentWithDefault:@"templateXslForPackagesFrameset"]) return NO;
	if (![self compareCurrentWithDefault:@"templateXslForPackagesTocFrameset"]) return NO;
	return YES;
}

- (BOOL)compareCurrentWithDefault:(NSString*)key
{
	return [[[delegate settings] objectForKey:key] isEqualToString:[[delegate defaultSettings] objectForKey:key]];
}

- (void)updateUsesDefaults
{
	[self setUsesDefaults:[NSNumber numberWithBool:[self hasDefaultSettings]]];
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


