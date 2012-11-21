//
//  RSAKey.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "RSAKey.h"
#import "Helper.h"

const NSString* kRSAKey_key = @"kRSAKey_key";
const NSString* kRSAKey_magnitude = @"kRSAKey_magnitude";

void logNumber(mpz_t number)
{
    char string[RSA_LENGTH];
    mpz_get_str(string, 16, number);
    printf("%s\n", string);
}

@implementation RSAKey

- (void)dealloc
{
    delete _key;
    delete _magnitude;
    
    [super dealloc];
}

- (id)initWithGMPKey:(mpz_t)key andMagnitude:(__mpz_struct *)magnitude
{
    if (self = [super init])
    {
        _key = new mpz_class(key);
        _magnitude = new mpz_class(magnitude);
    }
    
    return self;
}

- (id)initWithKey:(NSString *)key andMagnitude:(NSString *)magnitude
{
    if (self = [super init])
    {
        _key = new mpz_class([key getSTLString]);
        _magnitude = new mpz_class([magnitude getSTLString]);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    NSString* key = [coder decodeObjectForKey:(NSString*)kRSAKey_key];
    NSString* magnitude = [coder decodeObjectForKey:(NSString*)kRSAKey_magnitude];
    
    self = [self initWithKey:key andMagnitude:magnitude];
    
    return self;
}

- (int)processBytes:(char *)bytesToProcess length:(long)length toBytes:(char *)processedBytes mode:(int)mode
{
    bool encrypting = mode == MODE_ENCRYPT;
    
    mpz_t inputNumber, outputNumber;
    
    mpz_init(inputNumber);
    mpz_init(outputNumber);
    
    mpz_import(inputNumber, length, 1, sizeof(bytesToProcess[0]), 0, 0, bytesToProcess);
    mpz_powm(outputNumber, inputNumber, _key->get_mpz_t(), _magnitude->get_mpz_t());
    
    int maxLength = encrypting ? RSA_BLOCK_SIZE : RSA_BLOCK_BYTES_COUNT;
    int exportLength = (mpz_sizeinbase(outputNumber, BASE_2) + 8 - 1)/8;
    int offset = maxLength - exportLength;
    
    assert(offset >= 0);
    
    mpz_export(processedBytes + offset, NULL, 1, sizeof(char), 0, 0, outputNumber);
    
    return exportLength + offset;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:[self getKeyString] forKey:(NSString*)kRSAKey_key];
    [coder encodeObject:[self getMagnitudeString] forKey:(NSString*)kRSAKey_magnitude];
}

- (NSString*)getKeyString
{
    return [NSString stringWithSTLString:_key->get_str()];
}

- (NSString*)getMagnitudeString
{
    return [NSString stringWithSTLString:_magnitude->get_str()];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@\n\tkey = %@\n\tmagnitude = %@",
            [super description],
            [NSString stringWithSTLString:_key->get_str()],
            [NSString stringWithSTLString:_magnitude->get_str()]];
}

@end
