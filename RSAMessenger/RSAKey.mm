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
const NSString* kRSAKey_rsa_length = @"kRSAKey_rsa_length";

void logNumber(mpz_t number)
{
    char string[RSA_LENGTH_MAXIMUM];
    mpz_get_str(string, BASE_16, number);
    printf("%s\n", string);
}

@implementation RSAKey

- (void)dealloc
{
    delete _key;
    delete _magnitude;
    
    [super dealloc];
}

- (id)initWithGMPKey:(mpz_t)key magnitude:(__mpz_struct *)magnitude andLength:(int)length
{
    if (self = [super init])
    {
        _key = new mpz_class(key);
        _magnitude = new mpz_class(magnitude);
        _rsa_length = length;
    }
    
    return self;
}

- (id)initWithKey:(NSString *)key magnitude:(NSString *)magnitude andLength:(int)length
{
    if (self = [super init])
    {
        _key = new mpz_class([key getSTLString]);
        _magnitude = new mpz_class([magnitude getSTLString]);
        _rsa_length = length;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    NSString* key = [coder decodeObjectForKey:(NSString*)kRSAKey_key];
    NSString* magnitude = [coder decodeObjectForKey:(NSString*)kRSAKey_magnitude];
    int rsa_length = [coder decodeIntForKey:(NSString*)kRSAKey_rsa_length];
    
    self = [self initWithKey:key magnitude:magnitude andLength:rsa_length];
    
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
    
    int maxLength = encrypting ? [self getBlockSize] : [self getBlockEncryptedBytesCount];
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
    [coder encodeInt:_rsa_length forKey:(NSString*)kRSAKey_rsa_length];
}

- (int)getBitLength
{
    return _rsa_length;
}

- (int)getBlockSize
{
    return _rsa_length/8;
}

- (int)getBlockEncryptedBytesCount
{
    return _rsa_length/8 - 1;
}

- (int)getBlockReadBytesCount
{
    return _rsa_length/8 - 2;
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
