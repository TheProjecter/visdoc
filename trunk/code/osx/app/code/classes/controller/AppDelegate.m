/* See bottom of file for license and copyright information */

#import "AppDelegate.h"
#import "NSPanel+Fade.h"
#import "State.h"

static BOOL sOpenedLastOpenDocument = NO;
static BOOL sNeedsInstallerFeedBack = NO;
static float WINDOW_PRE_WAIT = 3.0;


@implementation AppDelegate

- (void)awakeFromNib
{
	if (sOpenedLastOpenDocument) return;
	NSString* lastOpened = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastopened"];
	NSArray* documents = [[NSApplication sharedApplication] orderedDocuments];
	if (lastOpened && [documents count] > 0) {
		NSDocument* document = [documents lastObject];
		[document setFileURL:[NSURL URLWithString:lastOpened]];
		NSError* outError;
		[document readFromURL:[NSURL URLWithString:lastOpened] ofType:@"DocumentType" error:&outError];
		sOpenedLastOpenDocument = YES;
	}
	
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{	
	[State resetCheck];
	
	if ([State needsToolsInstaller]) {
		showWindowTimer = [[NSTimer scheduledTimerWithTimeInterval:WINDOW_PRE_WAIT target:self selector:@selector(_showInstallToolsWindow:) userInfo:NULL repeats:NO] retain];
	} else if (sNeedsInstallerFeedBack) {
		if ([State needsInstall] || [State needsUpdate]) {
			// feedback: "not installed"
		} else {
			[self _showWindow:oInstalledOkFeedbackPanel];
			float showPanelDuration = 8.0;
			[NSTimer scheduledTimerWithTimeInterval:showPanelDuration target:self selector:@selector(_delayedHideWindow:) userInfo:oInstalledOkFeedbackPanel repeats:NO];
		}
		sNeedsInstallerFeedBack = NO;
	}
}

- (void)dealloc
{
	[self _killTimer];
	[super dealloc];
}

- (IBAction)orderFrontStandardAboutPanel:(id)sender
{
	NSImage* img = [NSImage imageNamed:@"VisDoc"];
	NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], @"Version",
							 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"], @"ApplicationName",
							 img, @"Image",
							 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"VAVDCopyright"], @"Copyright",
							 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], @"ApplicationVersion",
							 nil];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:options];
}

- (void)_killTimer
{
	if (showWindowTimer) {
		[showWindowTimer invalidate];	
		[showWindowTimer release];
		showWindowTimer = nil;
	}
}

- (IBAction)installToolsNow:(id)sender
{
	[self _hideWindow:oInstallToolsPanel];
	NSString* packagePath = [[NSBundle mainBundle] pathForResource:@"VisDoc Tools Installer" ofType:@"mpkg"];
	if (packagePath) {
		[[NSWorkspace sharedWorkspace] openFile:packagePath];
		sNeedsInstallerFeedBack = YES;
	} else {
		NSLog(@"Package installer could not be found. Please contact the author.");
	}
}

- (IBAction)installToolsLater:(id)sender
{
	[self _hideWindow:oInstallToolsPanel];
}

- (void)_showInstallToolsWindow:(NSTimer *)timer
{
	[self _killTimer];
	[self _showWindow:oInstallToolsPanel];
}

- (void)_showWindow:(NSPanel*)window
{
	[window setAlphaValue:0.0];
	[window makeKeyAndOrderFront:self];
	[window center];
	[window fadeInTo:0.9];
}

 - (void)_delayedHideWindow:(NSTimer*)timer
 {
	 NSPanel* window = [timer userInfo];
	 [self _hideWindow:window];
 }
			 
- (void)_hideWindow:(NSPanel*)window
{
	[window fadeOut];	
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

