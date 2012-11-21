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
            bool encrypting = _processingMode == MODE_ENCRYPT;
            
            int bufferSize = encrypting ? RSA_BLOCK_BYTES_COUNT : RSA_BLOCK_SIZE;
            int outputSize = encrypting ? RSA_BLOCK_SIZE : RSA_BLOCK_BYTES_COUNT;
            int readCount = encrypting ? RSA_BLOCK_READ_BYTES_COUNT : RSA_BLOCK_SIZE;
            
            uint8_t buffer[bufferSize];
            memset(buffer, 0, sizeof(buffer));
            
            long bytesReadCount = 0;
            bytesReadCount = [_inputStream read:buffer maxLength:readCount];
            
            if (bytesReadCount)
            {
                if (encrypting)
                {
                    //add padding bytes
                    int paddingByte = bufferSize - ((int)bytesReadCount % bufferSize);
                    for (int i = 0; i < paddingByte; i++)
                        buffer[bufferSize - 1 - i] = (char)paddingByte;
                }
                
                char outputBytes[outputSize];
                memset(outputBytes, 0, sizeof(outputBytes));
                
                int outputLength = [self.rsaKey processBytes:(char*)buffer
                                                      length:(encrypting ? bufferSize : bytesReadCount)
                                                     toBytes:outputBytes
                                                        mode:_processingMode];
                
                int paddingOffset = 0;
                
                //remove padding bytes
                if (!encrypting)
                    paddingOffset = outputBytes[outputSize - 1];
                
                if ([_outputStream hasSpaceAvailable])
                    [_outputStream write:(uint8_t*)outputBytes maxLength:outputLength - paddingOffset];
            }
            
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
