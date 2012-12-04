//
//  EncryptViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "EncryptViewController.h"
#import "MainWindowController.h"
#import "RSAEncryptor.h"
#import "RSAKeyPair.h"
#import "Helper.h"

@interface EncryptViewController ()

@end

@implementation EncryptViewController

@synthesize rsaPublicKey, fileToEncrypt;

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
    
    [keyFileDestination setInitialText:@"Drop Public Key Here"];
    [processedFileDestination setInitialText:@"Drop File To Encrypt Here"];
    [startButton setTitle:@"Encrypt"];
}

- (void)destinationView:(DropDestinationView *)view selectedFile:(NSString *)filePath
{
    if (view == keyFileDestination)
        [self checkKeyFile:filePath];
    
    if (view == processedFileDestination)
        self.fileToEncrypt = filePath;
    
    if (self.rsaPublicKey && self.fileToEncrypt)
        [startButton setEnabled:YES];
}

- (void)checkKeyFile:(NSString*)filePath
{
    self.rsaPublicKey = nil;
    
    @try {
        self.rsaPublicKey = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException* exception) { }
    @finally {
        if (!self.rsaPublicKey || ![self.rsaPublicKey isKindOfClass:[RSAKey class]])
        {
            [MainWindowController showErrorAlert:@"Wrong key file format"];
            [keyFileDestination reset];
        }
    }
}

- (void)startFileProcessing
{
    NSString *encryptedFilePath = [self.fileToEncrypt stringByAppendingString:@".rsa-encrypted"];
    
    [RSAEncryptor encryptFile:[NSURL fileURLWithPath:self.fileToEncrypt]
                       toFile:[NSURL fileURLWithPath:encryptedFilePath]
                      withKey:self.rsaPublicKey
                     delegate:self];
    
    [progressIndicator startAnimation:nil];
    [[self view] setSubViewsEnabled:NO];
}

- (void)rsaEncryptor:(RSAEncryptor *)encryptor percentComplete:(double)percent
{
    //TODO: implement
}

- (void)rsaEncryptorFinishedWorking:(RSAEncryptor *)encryptor
{
    [progressIndicator stopAnimation:nil];
    [[self view] setSubViewsEnabled:YES];
}

@end
