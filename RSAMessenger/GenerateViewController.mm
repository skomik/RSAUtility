//
//  GenerateViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "GenerateViewController.h"
#import "RSAKeyPair.h"
#import "Helper.h"

@interface GenerateViewController ()

@end

@implementation GenerateViewController

@synthesize currentRSAKeyPair=_currentRSAKeyPair;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)generatePressed:(id)sender
{
    self.currentRSAKeyPair = [RSAKeyPair randomPairWithLength:RSA_LENGTH_DEFAULT];
}

- (IBAction)savePressed:(id)sender
{
    if (!self.currentRSAKeyPair)
    {
        [self showEmptyKeyAlert];
        return;
    }
    
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    [savePanel setDirectoryURL:[Helper getWorkingDir]];
    [savePanel setExtensionHidden:NO];
    [savePanel setNameFieldStringValue:@"myRSAKeys.rsa-key-pair"];
    
    [savePanel beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow]
                      completionHandler:^(NSInteger result)
     {
         [Helper setWorkingDir:[savePanel directoryURL]];
         [savePanel orderOut:self];
         
         if (result == NSFileHandlingPanelOKButton) {
             [NSKeyedArchiver archiveRootObject:self.currentRSAKeyPair toFile:[[savePanel URL] path]];
         }
     }];
}

- (IBAction)loadPressed:(id)sender
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:[Helper getWorkingDir]];
    [openPanel setExtensionHidden:NO];
    
    [openPanel beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow]
                      completionHandler:^(NSInteger result)
     {
         [Helper setWorkingDir:[openPanel directoryURL]];
         [openPanel orderOut:self];
         
         if (result == NSFileHandlingPanelOKButton) {
             self.currentRSAKeyPair = [NSKeyedUnarchiver unarchiveObjectWithFile:[[openPanel URL] path]];
         }
     }];
}

- (IBAction)sharePressed:(id)sender
{
    if (!self.currentRSAKeyPair)
    {
        [self showEmptyKeyAlert];
        return;
    }
    
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    [savePanel setDirectoryURL:[Helper getWorkingDir]];
    [savePanel setExtensionHidden:NO];
    [savePanel setNameFieldStringValue:@"myRSAPublicKey.rsa-key"];
    
    [savePanel beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow]
                      completionHandler:^(NSInteger result)
     {
         [Helper setWorkingDir:[savePanel directoryURL]];
         [savePanel orderOut:self];
         
         if (result == NSFileHandlingPanelOKButton) {
             [NSKeyedArchiver archiveRootObject:[self.currentRSAKeyPair publicKey] toFile:[[savePanel URL] path]];
         }
     }];
}

- (void)setRSAKeyPair:(RSAKeyPair *)value;
{
    if (_currentRSAKeyPair)
    {
        [_currentRSAKeyPair release];
        _currentRSAKeyPair = nil;
    }
    
    _currentRSAKeyPair = [value retain];

    [self updateView];
}

- (void)showEmptyKeyAlert
{
    NSAlert* alert = [NSAlert alertWithMessageText:@"Empty Key"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"Generate key pair first or load it from file"];
    
    [alert runModal];
}

- (void)updateView
{
    NSString* publicKeyString = [[self.currentRSAKeyPair publicKey] getMagnitudeString];
    NSString* publicExponentString = [[self.currentRSAKeyPair publicKey] getKeyString];
    NSString* privateKeyString = [[self.currentRSAKeyPair privateKey] getKeyString];
    
    [publicKey setStringValue:(publicKeyString) ? publicKeyString : @""];
    [publicExponent setStringValue:(publicExponentString) ? publicExponentString : @""];
    [privateKey setStringValue:(privateKeyString) ? privateKeyString : @""];
}

@end
