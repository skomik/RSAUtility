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
#import "DragAndDropController.h"

enum { TAB_GENERATE, TAB_ENCRYPT, TAB_DECRYPT };

@interface MainWindowController ()

@end

@implementation MainWindowController

+ (void)showErrorAlert:(NSString *)message
{
    NSAlert* alert = [NSAlert alertWithMessageText:@"Error"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:message, nil];
    
    [alert runModal];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        [self setWindowFrameAutosaveName:@"MainWindow"];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.encryptViewController = [[[EncryptViewController alloc] initWithNibName:@"DragAndDropController" bundle:[NSBundle mainBundle]] autorelease];
    self.decryptViewController = [[[DecryptViewController alloc] initWithNibName:@"DragAndDropController" bundle:[NSBundle mainBundle]] autorelease];
    self.generateViewController = [[[GenerateViewController alloc] initWithNibName:@"GenerateViewController" bundle:[NSBundle mainBundle]] autorelease];
    self.dragAndDropController = [[[DragAndDropController alloc] initWithNibName:@"DragAndDropController" bundle:[NSBundle mainBundle]] autorelease];
    
    NSTabViewItem *item = [tabView tabViewItemAtIndex:TAB_GENERATE];
    [item setView:[self.generateViewController view]];
    
    item = [tabView tabViewItemAtIndex:TAB_ENCRYPT];
    [item setView:[self.encryptViewController view]];
    
    item = [tabView tabViewItemAtIndex:TAB_DECRYPT];
    [item setView:[self.decryptViewController view]];
    
    item = [tabView tabViewItemAtIndex:3];
    [item setView:[self.dragAndDropController view]];
}

@end
