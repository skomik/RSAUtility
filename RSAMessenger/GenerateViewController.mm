//
//  GenerateViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "GenerateViewController.h"
#import "RSAKeyPair.h"

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
    self.currentRSAKeyPair = [RSAKeyPair randomPairWithLength:RSA_LENGTH];
}

- (IBAction)savePressed:(id)sender
{
    
}

- (IBAction)loadPressed:(id)sender
{
    
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

- (void)updateView
{    
    [publicKey setStringValue:[[self.currentRSAKeyPair publicKey] getKeyString]];
    [publicExponent setStringValue:[[self.currentRSAKeyPair publicKey] getExponentString]];
    [privateKey setStringValue:[[self.currentRSAKeyPair privateKey] getKeyString]];
}

@end
