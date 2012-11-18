//
//  GenerateViewController.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RSAKeyPair;

@interface GenerateViewController : NSViewController
{
    IBOutlet NSTextField *publicKey;
    IBOutlet NSTextField *publicExponent;
    IBOutlet NSTextField *privateKey;
}

@property (nonatomic, retain, setter = setRSAKeyPair:) RSAKeyPair* currentRSAKeyPair;

- (IBAction)generatePressed:(id)sender;
- (IBAction)savePressed:(id)sender;
- (IBAction)loadPressed:(id)sender;

@end
