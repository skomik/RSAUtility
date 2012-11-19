//
//  EncryptViewController.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EncryptViewController : NSViewController
{
    IBOutlet NSTextField *publicKeyText;
    IBOutlet NSTextField *fileToEncryptText;
}

- (IBAction)publicKeyBrowsePressed:(id)sender;
- (IBAction)fileToEncryptBrowsePressed:(id)sender;
- (IBAction)encryptPressed:(id)sender;

@end
