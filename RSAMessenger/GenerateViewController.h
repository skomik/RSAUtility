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
    
    IBOutlet NSTextField *rsaLengthText;
    IBOutlet NSStepper *rsaLengthStepper;
}

@property (nonatomic, retain, setter = setRSAKeyPair:) RSAKeyPair* currentRSAKeyPair;
@property (nonatomic, retain, setter = setRSAKeyLength:) NSNumber* rsaKeyLength;

- (IBAction)generatePressed:(id)sender;
- (IBAction)savePressed:(id)sender;
- (IBAction)loadPressed:(id)sender;
- (IBAction)sharePressed:(id)sender;
- (IBAction)valueChanged:(id)sender;

@end
