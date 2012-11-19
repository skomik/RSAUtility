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

- (void)encryptString:(char *)stringToEncrypt toString:(char *)encryptedString
{
    unsigned long stringLength = strlen(stringToEncrypt);
    
    char tempString[4];
    char alignedString[stringLength * 3 + 1];
    strcpy(alignedString,"");
    
    for (int i = 0; i < stringLength; i++)
    {
        sprintf(tempString, "%03d", stringToEncrypt[i]);
        strcat(alignedString, tempString);
    }
    
    mpz_t cipher, message;
    mpz_init(cipher);
    mpz_init(message);
    
    mpz_set_str(message, alignedString, BASE_10);
    
    mpz_powm(cipher, message, _key->get_mpz_t(), _magnitude->get_mpz_t());
    
#ifdef DEBUG
    mpz_class cipher_class(cipher);
    mpz_class message_class(message);
    NSLog(@"aligned string: %s", alignedString); 
    NSLog(@"encrypting: %s", stringToEncrypt);
    NSLog(@"message: %@", [NSString stringWithSTLString:message_class.get_str()]);
    NSLog(@"cipher: %@", [NSString stringWithSTLString:cipher_class.get_str()]);
#endif
    
    mpz_get_str(encryptedString, BASE_10, cipher);
    
    mpz_clear(cipher);
    mpz_clear(message);
}

- (void)decryptString:(char *)stringToDecrypt toString:(char *)decryptedString
{
    NSUInteger maxLength = [[self getMagnitudeString] length];
    char messageString[maxLength];
    
    mpz_t message, cipher;
    mpz_init(message);
    mpz_init(cipher);
    
    mpz_set_str(cipher, stringToDecrypt, BASE_10);
    mpz_powm(message, cipher, _key->get_mpz_t(), _magnitude->get_mpz_t());
    mpz_get_str(messageString, BASE_10, message);
    
    mpz_clear(message);
    mpz_clear(cipher);
    
    //back to byte form
    unsigned long stringLength = strlen(messageString);
    char tempString[stringLength + 2];
    tempString[0] = '\0';
    
    //add missing leading zeroes
    if (stringLength % 3 == 2)
        strcat(tempString, "0");
    else if (stringLength % 3 == 1)
        strcat(tempString, "00");
    
    strcat(tempString, messageString);
    
    printf("message: %s\n", messageString);
    printf("tempString: %s\n", tempString);
    
    int tmpnum = 0;
    int iterator = 0;

    while(iterator <= strlen(tempString) - 3)
    {
        tmpnum = tempString[iterator] - 48;
        tmpnum = 10 * tmpnum + (tempString[iterator+1] - 48);
        tmpnum = 10 * tmpnum + (tempString[iterator+2] - 48);
        
        decryptedString[iterator/3] = tmpnum;
        
        iterator += 3;
    }
    
    decryptedString[iterator/3] = '\0';
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
