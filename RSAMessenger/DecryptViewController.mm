//
//  DecryptViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "DecryptViewController.h"
#import "MainWindowController.h"
#import "RSAEncryptor.h"
#import "RSAKeyPair.h"
#import "Helper.h"

@interface DecryptViewController ()
@end

@implementation DecryptViewController

@synthesize rsaKeyPair, fileToDecrypt;

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
    
    [keyFileDestination setInitialText:@"Drop Your Key Pair Here"];
    [processedFileDestination setInitialText:@"Drop File To Decrypt Here"];
    [startButton setTitle:@"Decrypt"];
}

- (void)destinationView:(DropDestinationView *)view selectedFile:(NSString *)filePath
{
    if (view == keyFileDestination)
        [self checkKeyFile:filePath];
    
    if (view == processedFileDestination)
        self.fileToDecrypt = filePath;
    
    if (self.rsaKeyPair && self.fileToDecrypt)
        [startButton setEnabled:YES];
}

- (void)checkKeyFile:(NSString*)filePath
{
    self.rsaKeyPair = nil;
    
    @try {
        self.rsaKeyPair = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException* exception) { }
    @finally {
        if (!self.rsaKeyPair || ![self.rsaKeyPair isKindOfClass:[RSAKeyPair class]])
        {
            [MainWindowController showErrorAlert:@"Wrong key file format"];
            [keyFileDestination reset];
        }
    }
}

- (void)startFileProcessing
{
    NSString *decryptedFilePath = [[self.fileToDecrypt stringByReplacingOccurrencesOfString:@".rsa-encrypted" withString:@""] stringByAppendingString:@".rsa-decrypted"];
    
    [RSAEncryptor decryptFile:[NSURL fileURLWithPath:self.fileToDecrypt]
                       toFile:[NSURL fileURLWithPath:decryptedFilePath]
                      withKey:self.rsaKeyPair.privateKey
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
