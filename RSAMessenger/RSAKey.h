//
//  RSAKey.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libs/gmp/gmpxx.h"

#define BASE_10 10
#define BASE_2 2

#define RSA_LENGTH 1024
#define RSA_BLOCK_SIZE RSA_LENGTH/8
#define RSA_BLOCK_BYTES_COUNT (RSA_LENGTH/8 - 1)
#define RSA_BLOCK_READ_BYTES_COUNT RSA_BLOCK_BYTES_COUNT - 1

enum { MODE_ENCRYPT, MODE_DECRYPT };

@interface RSAKey : NSObject
{
    mpz_class* _key;
    mpz_class* _magnitude;
}

- (id)initWithCoder:(NSCoder*)coder;
- (id)initWithGMPKey:(mpz_t)key andMagnitude:(mpz_t)magnitude;
- (id)initWithKey:(NSString*)key andMagnitude:(NSString*)magnitude;

- (int)processBytes:(char *)bytesToProcess length:(long)length toBytes:(char *)processedBytes mode:(int)mode;

- (void)encodeWithCoder:(NSCoder*)coder;

- (NSString*)getKeyString;
- (NSString*)getMagnitudeString;

@end