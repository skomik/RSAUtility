//
//  RSAKey.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libs/gmp/gmpxx.h"

@interface RSAKey : NSObject
{
    mpz_class* _e;
    mpz_class* _key;
}

- (id)initFromFile:(NSURL*)filePath;
- (id)initWithGMPKey:(mpz_t)key andE:(mpz_t)e;
- (id)initWithKey:(NSString*)key andE:(NSString*)e;

- (NSString*)getExponentString;
- (NSString*)getKeyString;

- (NSString*)encryptString:(NSString*)string;
- (NSString*)decryptString:(NSString*)string;

- (void)encryptFile:(NSURL*)fileToEncrypt toFile:(NSURL*)encryptedFile;
- (void)decryptFile:(NSURL*)fileToDecrypt toFile:(NSURL*)decryptedFile;

@end