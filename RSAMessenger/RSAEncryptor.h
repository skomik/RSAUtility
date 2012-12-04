//
//  RSAEncryptor.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 19.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSAKey, RSAEncryptor;

@protocol RSAEncryptorDelegate <NSObject>
- (void)rsaEncryptorFinishedWorking:(RSAEncryptor*)encryptor;
@optional
- (void)rsaEncryptor:(RSAEncryptor*)encryptor percentComplete:(double)percent;
@end

@interface RSAEncryptor : NSObject <NSStreamDelegate>
{
    NSInputStream* _inputStream;
    NSOutputStream* _outputStream;
    
    int _processingMode;
}

+ (void)encryptFile:(NSURL*)fileToEncrypt toFile:(NSURL*)encryptedFile withKey:(RSAKey*)rsaKey delegate:(NSObject<RSAEncryptorDelegate>*)delegate;
+ (void)decryptFile:(NSURL*)fileToDecrypt toFile:(NSURL*)decryptedFile withKey:(RSAKey*)rsaKey delegate:(NSObject<RSAEncryptorDelegate>*)delegate;

@end
