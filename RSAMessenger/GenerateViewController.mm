//
//  GenerateViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "GenerateViewController.h"
#import "MainWindowController.h"
#import "RSAKeyPair.h"
#import "Helper.h"

@interface GenerateViewController ()

@end

@implementation GenerateViewController

@synthesize currentRSAKeyPair=_currentRSAKeyPair;
@synthesize rsaKeyLength=_rsaKeyLength;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rsaKeyLength = [NSNumber numberWithInt:RSA_LENGTH_DEFAULT];
    }
    
    return self;
}

- (IBAction)generatePressed:(id)sender
{
    if ([rsaLengthText intValue] != [self.rsaKeyLength intValue])
        [self valueChanged:rsaLengthText];
    
    self.currentRSAKeyPair = [RSAKeyPair randomPairWithLength:[self.rsaKeyLength intValue]];
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
             @try {
                 self.currentRSAKeyPair = [NSKeyedUnarchiver unarchiveObjectWithFile:[[openPanel URL] path]];
             }
             @catch (NSException* exception) { }
             @finally {
                 if (!self.currentRSAKeyPair)
                    [MainWindowController showErrorAlert:@"Wrong key file format"]; 
             }
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

- (void)valueChanged:(id)sender
{
    int value = [sender intValue];
    
    if (value < [rsaLengthStepper minValue])
        value = [rsaLengthStepper minValue];
    else if (value > [rsaLengthStepper maxValue])
        value = [rsaLengthStepper maxValue];
    
    self.rsaKeyLength = [NSNumber numberWithInt:value];
    
    [self updateValues];
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

- (void)setRSAKeyLength:(NSNumber *)value
{
    if (_rsaKeyLength)
        [_rsaKeyLength release];
    
    _rsaKeyLength = [value retain];
    
    [self updateValues];
}

- (void)showEmptyKeyAlert
{
    [MainWindowController showErrorAlert:@"Empty key. Generate key pair first or load it from file"];
}

- (void)updateValues
{
    NSString *valueString = [NSString stringWithFormat:@"%d", [self.rsaKeyLength intValue]];
    
    [rsaLengthText setStringValue:valueString];
    [rsaLengthStepper setStringValue:valueString];
}

- (void)updateView
{
    NSString* publicKeyString = [[self.currentRSAKeyPair publicKey] getMagnitudeString];
    NSString* publicExponentString = [[self.currentRSAKeyPair publicKey] getKeyString];
    NSString* privateKeyString = [[self.currentRSAKeyPair privateKey] getKeyString];
    
    [publicKey setStringValue:(publicKeyString) ? publicKeyString : @""];
    [publicExponent setStringValue:(publicExponentString) ? publicExponentString : @""];
    [privateKey setStringValue:(privateKeyString) ? privateKeyString : @""];
    
    [self setRSAKeyLength:[NSNumber numberWithInt:self.currentRSAKeyPair.bitLength]];
}



@end
