//
//  DecryptViewController.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragAndDropController.h"
#import "RSAEncryptor.h"

@class RSAKeyPair;

@interface DecryptViewController : DragAndDropController <RSAEncryptorDelegate>

@property (nonatomic, retain) RSAKeyPair* rsaKeyPair;
@property (nonatomic, retain) NSString* fileToDecrypt;

@end
