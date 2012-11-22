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

//#define RSA_BLOCK_SIZE RSA_LENGTH/8
//#define RSA_BLOCK_BYTES_COUNT (RSA_LENGTH/8 - 1)
//#define RSA_BLOCK_READ_BYTES_COUNT RSA_BLOCK_BYTES_COUNT - 1

enum { MODE_ENCRYPT, MODE_DECRYPT };

@interface RSAKey : NSObject
{
    int _rsa_length;
    
    mpz_class* _key;
    mpz_class* _magnitude;
}

- (id)initWithCoder:(NSCoder*)coder;
- (id)initWithGMPKey:(mpz_t)key magnitude:(mpz_t)magnitude andLength:(int)length;
- (id)initWithKey:(NSString*)key magnitude:(NSString*)magnitude andLength:(int)length;

- (int)getBitLength; //key length in bits (1024 default)
- (int)getBlockSize; //block size in bytes
- (int)getBlockEncryptedBytesCount; //number of bytes, encrypted
- (int)getBlockReadBytesCount; //number of bytes, read from file to be encrypted

- (int)processBytes:(char *)bytesToProcess length:(long)length toBytes:(char *)processedBytes mode:(int)mode;

- (void)encodeWithCoder:(NSCoder*)coder;

- (NSString*)getKeyString;
- (NSString*)getMagnitudeString;

@end