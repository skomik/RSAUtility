//
//  RSAKey.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "RSAKey.h"
#import "Helper.h"

const NSString* kRSAKey_e = @"kRSAKey_e";
const NSString* kRSAKey_key = @"kRSAKey_key";

@implementation RSAKey

- (void)dealloc
{
    delete _e;
    delete _key;
    
    [super dealloc];
}

- (id)initWithGMPKey:(mpz_t)key andExponent:(mpz_t)e
{
    if (self = [super init])
    {
        _e = new mpz_class(e);
        _key = new mpz_class(key);
    }
    
    return self;
}

- (id)initWithKey:(NSString *)key andExponent:(NSString *)e
{
    if (self = [super init])
    {
        _e = new mpz_class([e getSTLString]);
        _key = new mpz_class([key getSTLString]);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    NSString* exponent = [coder decodeObjectForKey:(NSString*)kRSAKey_e];
    NSString* key = [coder decodeObjectForKey:(NSString*)kRSAKey_key];
    
    self = [self initWithKey:key andExponent:exponent];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:[self getExponentString] forKey:(NSString*)kRSAKey_e];
    [coder encodeObject:[self getKeyString] forKey:(NSString*)kRSAKey_key];
}

- (NSString*)getExponentString
{
    return [NSString stringWithSTLString:_e->get_str()];
}

- (NSString*)getKeyString
{
    return [NSString stringWithSTLString:_key->get_str()];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@\n\te = %@\n\tkey = %@",
            [super description],
            [NSString stringWithSTLString:_e->get_str()],
            [NSString stringWithSTLString:_key->get_str()]];
}

- (NSString*)encryptString:(NSString*)string
{
    return @"";
}

- (NSString*)decryptString:(NSString*)string
{
    return @"";
}

- (void)encryptFile:(NSURL *)fileToEncrypt toFile:(NSURL *)encryptedFile
{
    
}

- (void)decryptFile:(NSURL *)fileToDecrypt toFile:(NSURL *)decryptedFile
{
    
}


@end
