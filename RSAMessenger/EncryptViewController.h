//
//  EncryptViewController.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragAndDropController.h"
#import "RSAEncryptor.h"

@class RSAKey;

@interface EncryptViewController : DragAndDropController <RSAEncryptorDelegate>

@property (nonatomic, retain) RSAKey* rsaPublicKey;
@property (nonatomic, retain) NSString* fileToEncrypt;

@end
