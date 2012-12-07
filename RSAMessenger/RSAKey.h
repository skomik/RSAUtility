//
//  RSAKey.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libs/gmp/gmpxx.h"

#define BASE_2 2
#define BASE_10 10
#define BASE_16 16

#define RSA_LENGTH_DEFAULT 1024
#define RSA_LENGTH_MAXIMUM 2048

enum { MODE_ENCRYPT, MODE_DECRYPT };

@interface RSAKey : NSObject
{
    int _rsa_length;
    
    mpz_class* _key;
    mpz_class* _magnitude;
    
    //Chinese remainder theorem
    BOOL supportsChineseRemainder;
    mpz_class* _p;
    mpz_class* _q;
    mpz_class* _dp;
    mpz_class* _dq;
    mpz_class* _pinv;
    mpz_class* _qinv;
}

- (id)initWithCoder:(NSCoder*)coder;
- (id)initWithGMPKey:(mpz_t)key magnitude:(mpz_t)magnitude andLength:(int)length;
- (id)initWithKey:(NSString*)key magnitude:(NSString*)magnitude andLength:(int)length;

- (void)setChineseRemainder_p:(mpz_t)p q:(mpz_t)q dp:(mpz_t)dp dq:(mpz_t)dq pinv:(mpz_t)pinv qinv:(mpz_t)qinv;

- (int)getBitLength; //key length in bits (1024 default)
- (int)getBlockSize; //block size in bytes
- (int)getBlockEncryptedBytesCount; //number of bytes, encrypted
- (int)getBlockReadBytesCount; //number of bytes, read from file to be encrypted

- (int)processBytes:(char *)bytesToProcess length:(long)length toBytes:(char *)processedBytes mode:(int)mode;

- (void)encodeWithCoder:(NSCoder*)coder;

- (NSString*)getKeyString;
- (NSString*)getMagnitudeString;

@end