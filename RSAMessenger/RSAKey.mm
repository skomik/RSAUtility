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
