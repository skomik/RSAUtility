//
//  RSAEncryptor.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "RSAEncryptor.h"
#import "RSAKey.h"

enum { MODE_ENCRYPT, MODE_DECRYPT };

@interface RSAEncryptor()
@property (nonatomic, assign) NSObject<RSAEncryptorDelegate>* delegate;
@end

@implementation RSAEncryptor
@synthesize delegate;

+ (void)encryptFile:(NSURL *)fileToEncrypt toFile:(NSURL *)encryptedFile withKey:(RSAKey *)rsaKey delegate:(NSObject<RSAEncryptorDelegate> *)delegate
{
    RSAEncryptor *encryptor = [[RSAEncryptor alloc] initWithMode:MODE_ENCRYPT
                                                           input:fileToEncrypt
                                                          output:encryptedFile];
    
    [encryptor setDelegate:delegate];
    [encryptor startProcess];
}

+ (void)decryptFile:(NSURL *)fileToDecrypt toFile:(NSURL *)decryptedFile withKey:(RSAKey *)rsaKey delegate:(NSObject<RSAEncryptorDelegate> *)delegate
{
    RSAEncryptor *encryptor = [[RSAEncryptor alloc] initWithMode:MODE_DECRYPT
                                                           input:fileToDecrypt
                                                          output:decryptedFile];
    
    [encryptor setDelegate:delegate];
    [encryptor startProcess];
}

- (void)dealloc
{
    [_inputStream release];
    [_outputStream release];
    
    [super dealloc];
}

- (id)initWithMode:(int)mode input:(NSURL*)inputURL output:(NSURL*)outputURL
{
    if (self = [super init])
    {
        _processingMode = mode;
        
        _inputStream = [[NSInputStream alloc] initWithURL:inputURL];
        [_inputStream setDelegate:self];
        [_inputStream open];
        
        _outputStream = [[NSOutputStream alloc] initWithURL:outputURL append:NO];
        [_outputStream open];
    }
    
    return self;
}

- (void)startProcess;
{
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasBytesAvailable:
        {            
            uint8_t buf[RSA_BLOCK_BYTES_COUNT];
            long len = 0;
            len = [_inputStream read:buf maxLength:RSA_BLOCK_BYTES_COUNT];
            if (len)
            {
                for (int i = 0; i < len; i++)
                    printf("%c", buf[i]);
                printf("\n");
            }
            
//            if (_processingMode == MODE_ENCRYPT)
//            {
//            }
//            else if (_processingMode == MODE_DECRYPT)
//            {
//            }
            
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            [_outputStream close];
            [_inputStream close];
            [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                                    forMode:NSDefaultRunLoopMode];
            
            if (delegate && [delegate respondsToSelector:@selector(rsaEncryptorFinishedWorking:)])
                [delegate rsaEncryptorFinishedWorking:self];
            
            [self release];
            break;
        }
    }
}

@end
