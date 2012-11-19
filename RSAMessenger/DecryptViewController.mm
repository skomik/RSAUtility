//
//  DecryptViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "DecryptViewController.h"
#import "RSAEncryptor.h"
#import "RSAKeyPair.h"

@interface DecryptViewController ()

@end

@implementation DecryptViewController

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
    [keyPairText setStringValue:@"/Users/skomik/Desktop/temp/myRSAKeys.rsa-key-pair"];
    [fileToDecryptText setStringValue:@"/Users/skomik/Desktop/temp/tongue_03.png.rsa-encrypted"];
}

- (IBAction)keyPairBrowsePressed:(id)sender
{
    
}

- (IBAction)fileToDecryptBrowsePressed:(id)sender
{
    
}

- (IBAction)decryptPressed:(id)sender
{
    NSString *keyPath = [keyPairText stringValue];
    NSString *filePath = [fileToDecryptText stringValue];
    NSString *decryptedFilePath = [[filePath stringByReplacingOccurrencesOfString:@".rsa-encrypted" withString:@""] stringByAppendingString:@".rsa-decrypted"];
    
    RSAKey *privateKey = [[NSKeyedUnarchiver unarchiveObjectWithFile:keyPath] privateKey];
    
    [RSAEncryptor decryptFile:[NSURL fileURLWithPath:filePath]
                       toFile:[NSURL fileURLWithPath:decryptedFilePath]
                      withKey:privateKey
                     delegate:nil];
}

@end
