//
//  RSAKey.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libs/gmp/gmpxx.h"

#define RSA_LENGTH 1024
#define RSA_BLOCK_BYTES_COUNT 10

@interface RSAKey : NSObject
{
    mpz_class* _key;
    mpz_class* _magnitude;
}

- (id)initWithCoder:(NSCoder*)coder;
- (id)initWithGMPKey:(mpz_t)key andMagnitude:(mpz_t)magnitude;
- (id)initWithKey:(NSString*)key andMagnitude:(NSString*)magnitude;

- (void)encodeWithCoder:(NSCoder*)coder;

- (NSString*)getKeyString;
- (NSString*)getMagnitudeString;

@end