//
//  DecryptViewController.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DecryptViewController : NSViewController
{
    IBOutlet NSTextField *keyPairText;
    IBOutlet NSTextField *fileToDecryptText;
}

- (IBAction)keyPairBrowsePressed:(id)sender;
- (IBAction)fileToDecryptBrowsePressed:(id)sender;
- (IBAction)decryptPressed:(id)sender;

@end
