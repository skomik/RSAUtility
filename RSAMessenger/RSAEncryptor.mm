//
//  RSAEncryptor.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "RSAEncryptor.h"
#import "RSAKey.h"
#import "Helper.h"

enum { MODE_ENCRYPT, MODE_DECRYPT };

@interface RSAEncryptor()
@property (nonatomic, assign) NSObject<RSAEncryptorDelegate>* delegate;
@property (nonatomic, retain) RSAKey* rsaKey;
@end

@implementation RSAEncryptor
@synthesize delegate;

+ (void)encryptFile:(NSURL *)fileToEncrypt toFile:(NSURL *)encryptedFile withKey:(RSAKey *)rsaKey delegate:(NSObject<RSAEncryptorDelegate> *)delegate
{
    RSAEncryptor *encryptor = [[RSAEncryptor alloc] initWithMode:MODE_ENCRYPT
                                                           input:fileToEncrypt
                                                          output:encryptedFile];
    
    [encryptor setDelegate:delegate];
    [encryptor setRsaKey:rsaKey];
    [encryptor startProcess];
}

+ (void)decryptFile:(NSURL *)fileToDecrypt toFile:(NSURL *)decryptedFile withKey:(RSAKey *)rsaKey delegate:(NSObject<RSAEncryptorDelegate> *)delegate
{
    RSAEncryptor *encryptor = [[RSAEncryptor alloc] initWithMode:MODE_DECRYPT
                                                           input:fileToDecrypt
                                                          output:decryptedFile];
    
    [encryptor setDelegate:delegate];
    [encryptor setRsaKey:rsaKey];
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
            if (_processingMode == MODE_ENCRYPT)
            {
                uint8_t buffer[RSA_BLOCK_BYTES_COUNT];
                memset(buffer, 0, sizeof(buffer));
                
                long bytesReadCount = 0;
                bytesReadCount = [_inputStream read:buffer maxLength:RSA_BLOCK_READ_BYTES_COUNT];
                
                if (bytesReadCount)
                {
                    //add padding bytes
                    int paddingByte = RSA_BLOCK_BYTES_COUNT - ((int)bytesReadCount % RSA_BLOCK_BYTES_COUNT);
                    for (int i = 0; i < paddingByte; i++)
                        buffer[RSA_BLOCK_BYTES_COUNT - 1 - i] = (char)paddingByte;
                    
                    char encryptedBytes[RSA_BLOCK_SIZE];
                    memset(encryptedBytes, 0, sizeof(encryptedBytes));
                    
                    int encryptedLength = [self.rsaKey encryptBytes:(char*)buffer length:RSA_BLOCK_BYTES_COUNT toBytes:encryptedBytes];
                    
                    if ([_outputStream hasSpaceAvailable])
                        [_outputStream write:(uint8_t*)encryptedBytes maxLength:encryptedLength];
                }
            }
            else if (_processingMode == MODE_DECRYPT)
            {
                uint8_t buffer[RSA_BLOCK_SIZE];
                long bytesReadCount = 0;
                bytesReadCount = [_inputStream read:buffer maxLength:RSA_BLOCK_SIZE];
                
                if (bytesReadCount)
                {                    
                    char decryptedBytes[RSA_BLOCK_BYTES_COUNT];
                    memset(decryptedBytes, 0, sizeof(decryptedBytes));
                    
                    int decryptedLength = [self.rsaKey decryptBytes:(char*)buffer length:bytesReadCount toBytes:decryptedBytes];
                    
                    //remove padding bytes
                    int paddingOffset = decryptedBytes[RSA_BLOCK_BYTES_COUNT - 1];
                    
                    if ([_outputStream hasSpaceAvailable])
                        [_outputStream write:(uint8_t*)decryptedBytes maxLength:decryptedLength - paddingOffset];
                }
            }
            else
                assert(false);
            
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
