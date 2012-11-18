//
//  MainWindowController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "MainWindowController.h"
#import "EncryptViewController.h"
#import "DecryptViewController.h"
#import "GenerateViewController.h"

enum { TAB_GENERATE, TAB_ENCRYPT, TAB_DECRYPT };

@interface MainWindowController ()

@end

@implementation MainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.encryptViewController = [[[EncryptViewController alloc] initWithNibName:@"EncryptViewController" bundle:[NSBundle mainBundle]] autorelease];
    self.decryptViewController = [[[DecryptViewController alloc] initWithNibName:@"DecryptViewController" bundle:[NSBundle mainBundle]] autorelease];
    self.generateViewController = [[[GenerateViewController alloc] initWithNibName:@"GenerateViewController" bundle:[NSBundle mainBundle]] autorelease];
    
    NSTabViewItem *item = [tabView tabViewItemAtIndex:TAB_GENERATE];
    [item setView:[self.generateViewController view]];
    
    item = [tabView tabViewItemAtIndex:TAB_ENCRYPT];
    [item setView:[self.encryptViewController view]];
    
    item = [tabView tabViewItemAtIndex:TAB_DECRYPT];
    [item setView:[self.decryptViewController view]];
}

@end
