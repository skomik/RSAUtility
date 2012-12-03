//
//  AppDelegate.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

-(IBAction)newDocument:(id)sender
{
	if (mainWindowController == NULL)
		mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindowController"];
	
	[mainWindowController showWindow:self];
}

-(BOOL)validateMenuItem:(NSMenuItem*)theMenuItem
{
    BOOL enable = [self respondsToSelector:[theMenuItem action]];
    
    // disable "New" if the window is already up
	if ([theMenuItem action] == @selector(newDocument:))
	{
		if ([[mainWindowController window] isKeyWindow])
			enable = NO;
	}
	return enable;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self newDocument:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
