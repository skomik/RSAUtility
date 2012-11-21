//
//  EncryptViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "EncryptViewController.h"
#import "RSAEncryptor.h"

@interface EncryptViewController ()

@end

@implementation EncryptViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //TODO: remove
    [publicKeyText setStringValue:@"/Users/skomik/Desktop/temp/myRSAPublicKey.rsa-key"];
    [fileToEncryptText setStringValue:@"/Users/skomik/Desktop/temp/photo.jpg"];
}

- (IBAction)publicKeyBrowsePressed:(id)sender
{
    
}

- (IBAction)fileToEncryptBrowsePressed:(id)sender
{
    
}

- (IBAction)encryptPressed:(id)sender
{
    NSString *keyPath = [publicKeyText stringValue];
    NSString *filePath = [fileToEncryptText stringValue];
    NSString *encryptedFilePath = [filePath stringByAppendingString:@".rsa-encrypted"];
    
    RSAKey *publicKey = [NSKeyedUnarchiver unarchiveObjectWithFile:keyPath];
    
    [RSAEncryptor encryptFile:[NSURL fileURLWithPath:filePath]
                       toFile:[NSURL fileURLWithPath:encryptedFilePath]
                      withKey:publicKey
                     delegate:nil];
}

@end
