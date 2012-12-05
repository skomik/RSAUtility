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
@property (nonatomic, retain) NSString* decryptedFile;
@end

@implementation DecryptViewController

@synthesize decryptedFile;

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
    self.decryptedFile = [[self.fileToDecrypt stringByReplacingOccurrencesOfString:@".rsa-encrypted" withString:@""] stringByAppendingString:@".rsa-decrypted"];
    
    [RSAEncryptor decryptFile:[NSURL fileURLWithPath:self.fileToDecrypt]
                       toFile:[NSURL fileURLWithPath:self.decryptedFile]
                      withKey:self.rsaKeyPair.privateKey
                     delegate:self];
    
    [progressIndicator startAnimation:nil];
    [[self view] setSubViewsEnabled:NO];
    
    [self logString:[NSString stringWithFormat:@"Started decrypting %@", self.fileToDecrypt]];
    
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
    
    NSData *fileData = [NSData dataWithContentsOfFile:self.decryptedFile];
    NSString *fileHash = [Helper sha1Hash:fileData];
    
    [self logString:[NSString stringWithFormat:@"Finished decrypting %@", self.fileToDecrypt]];
    [self logString:[NSString stringWithFormat:@"Decryption took %.3f seconds", interval]];
    [self logString:[NSString stringWithFormat:@"Decrypted file hash: %@", fileHash]];
}

@end
