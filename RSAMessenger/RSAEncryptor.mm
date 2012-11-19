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
            NSUInteger keyLength = [[self.rsaKey getMagnitudeString] length];
            
            if (_processingMode == MODE_ENCRYPT)
            {
                uint8_t buffer[RSA_BLOCK_BYTES_COUNT + 1];
                long bytesReadCount = 0;
                bytesReadCount = [_inputStream read:buffer maxLength:RSA_BLOCK_BYTES_COUNT];
                
                if (bytesReadCount)
                {
                    //making string out of read bytes
                    buffer[bytesReadCount] = '\0';
                    
                    char* inputString = (char *)buffer;
                    char outputString[keyLength];
                    
                    [self.rsaKey encryptString:inputString toString:outputString];
                    
                    for (unsigned long i = strlen(outputString); i < keyLength - 1; i++)
                        outputString[i] = '$';
                    outputString[keyLength - 1] = '\n';
                    
                    if ([_outputStream hasSpaceAvailable])
                        [_outputStream write:(uint8_t*)outputString maxLength:keyLength];
                }
            }
            else if (_processingMode == MODE_DECRYPT)
            {
                uint8_t buffer[keyLength + 1];
                long bytesReadCount = 0;
                bytesReadCount = [_inputStream read:buffer maxLength:keyLength];
                
                if (bytesReadCount)
                {
                    //making string out of read bytes
                    long iterator = bytesReadCount;
                    while (buffer[iterator] < '0' || buffer[iterator] > '9') { iterator--; }
                    buffer[iterator+1] = '\0';
                    
                    char* inputString = (char*)buffer;
                    char outputString[RSA_BLOCK_BYTES_COUNT + 1];
                    
                    printf("input: %s\n", inputString);
                    
                    [self.rsaKey decryptString:inputString toString:outputString];
                    
                    printf("output: %s\n", outputString);
                    
                    if ([_outputStream hasSpaceAvailable])
                        [_outputStream write:(uint8_t*)outputString maxLength:strlen(outputString)];
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
