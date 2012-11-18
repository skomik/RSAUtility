//
//  RSAKey.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "RSAKey.h"
#import "Helper.h"

@implementation RSAKey

- (void)dealloc
{
    delete _e;
    delete _key;
    
    [super dealloc];
}

- (id)initFromFile:(NSURL *)filePath
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (id)initWithGMPKey:(mpz_t)key andE:(mpz_t)e
{
    if (self = [super init])
    {
        _e = new mpz_class(e);
        _key = new mpz_class(key);
    }
    
    return self;
}

- (id)initWithKey:(NSString *)key andE:(NSString *)e
{
    if (self = [super init])
    {
        _e = new mpz_class();
        _key = new mpz_class();
    }
    
    return self;
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
