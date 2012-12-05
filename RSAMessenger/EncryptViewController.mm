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
    
    NSData* fileData = [NSData dataWithContentsOfFile:self.fileToEncrypt];
    NSString* fileHash = [Helper sha1Hash:fileData];
    
    [self logString:[NSString stringWithFormat:@"Started encrypting %@", self.fileToEncrypt]];
    [self logString:[NSString stringWithFormat:@"Encrypted file hash: %@", fileHash]];
    
    self.startTime = [NSDate date];
}

- (void)rsaEncryptor:(RSAEncryptor *)encryptor percentComplete:(double)percent
{
    [progressIndicator setDoubleValue:percent];
}

- (void)rsaEncryptorFinishedWorking:(RSAEncryptor *)encryptor
{
    NSDate* finishTime = [NSDate date];
    NSTimeInterval interval = [finishTime timeIntervalSinceDate:self.startTime];
    
    [[self view] setSubViewsEnabled:YES];
    
    [self logString:[NSString stringWithFormat:@"Finished encrypting %@", self.fileToEncrypt]];
    [self logString:[NSString stringWithFormat:@"Encryption took %.3f seconds", interval]];
}

@end
