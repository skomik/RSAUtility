//
//  RSAKeyPair.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "RSAKeyPair.h"

const NSString* kRSAKeyPair_publicKey = @"kRSAKeyPair_publicKey";
const NSString* kRSAKeyPair_privateKey = @"kRSAKeyPair_privateKey";

void RSA_initRandom()
{
    time_t time_elapsed;
    time(&time_elapsed);
    srand((unsigned)time_elapsed);
}

void RSA_generateKeyPair(int length, mpz_t &e, mpz_t &n, mpz_t &d)
{
    int primeSize = length/2;
    
    mpz_t p,q;
    
    mpz_init(p);
    mpz_init(q);
    
    char* p_str = new char[primeSize+1];
    char* q_str = new char[primeSize+1];
    
    p_str[0] = '1';
    q_str[0] = '1';
    
    for(int i=1;i<primeSize;i++)
        p_str[i] = (int)(2.0*rand()/(RAND_MAX+1.0)) + 48;
    
    for(int i=1;i<primeSize;i++)
        q_str[i] = (int)(2.0*rand()/(RAND_MAX+1.0)) + 48;
    
    p_str[primeSize] = '\0';
    q_str[primeSize] = '\0';
    
    mpz_set_str(p,p_str,BASE_2);
    mpz_set_str(q,q_str,BASE_2);
    
    mpz_nextprime(p,p);
    mpz_nextprime(q,q);
    
    mpz_get_str(p_str,BASE_10,p);
    mpz_get_str(q_str,BASE_10,q);
    
    printf("Random Prime 'p' = %s\n",p_str);
    printf("Random Prime 'q' = %s\n",q_str);
    
    /*
     *  Step 2 : Calculate n (=pq) ie the 1024 bit modulus
     *  and x (=(p-1)(q-1)).
     */
    
    mpz_t x;
    
    mpz_init(x);
    
    /* Calculate n... */
    
    mpz_mul(n,p,q);
    
    /* Calculate x... */
    
    mpz_t p_minus_1,q_minus_1;
    
    mpz_init(p_minus_1);
    mpz_init(q_minus_1);
    
    mpz_sub_ui(p_minus_1,p,(unsigned long int)1);
    mpz_sub_ui(q_minus_1,q,(unsigned long int)1);
    
    mpz_mul(x,p_minus_1,q_minus_1);
    
    /*
     *  Step 3 : Get small odd integer e such that gcd(e,x) = 1.
     */
    
    mpz_t gcd;
    mpz_init(gcd);
    
    /*
     *  Assuming that 'e' will not exceed the range
     *  of a long integer, which is quite a reasonable
     *  assumption.
     */
    
    unsigned long int e_int = 65537;
    
    while(true)
    {
        mpz_gcd_ui(gcd,x,e_int);
        
        if(mpz_cmp_ui(gcd,(unsigned long int)1)==0)
            break;
        
        /* try the next odd integer... */
        e_int += 2;
    }
    
    mpz_set_ui(e,e_int);
    
    char d_str[1000];
    
    if(mpz_invert(d,e,x)==0)
    {
        printf("\nOOPS : Could not find multiplicative inverse!\n");
        printf("\nTrying again...");
        RSA_generateKeyPair(length, e, n, d);
    }
    
    mpz_get_str(d_str,BASE_10,d);
    
    delete p_str;
    delete q_str;
    
    mpz_clear(p);
    mpz_clear(q);
    mpz_clear(x);
    mpz_clear(p_minus_1);
    mpz_clear(q_minus_1);
    mpz_clear(gcd);
}

@implementation RSAKeyPair

@synthesize publicKey=_publicKey;
@synthesize privateKey=_privateKey;

+ (RSAKeyPair*)randomPairWithLength:(int)length
{
    return [[[RSAKeyPair alloc] initRandomWithLength:length] autorelease];
}

- (void)dealloc
{
    [_publicKey release];
    [_privateKey release];
    
    [super dealloc];
}

- (id)initRandomWithLength:(int)length
{
    if (self = [super init])
    {
        mpz_t e, n, d;
        
        mpz_init(e);
        mpz_init(n);
        mpz_init(d);
        
        RSA_initRandom();
        RSA_generateKeyPair(length, e, n, d);
        
        _publicKey = [[RSAKey alloc] initWithGMPKey:e andMagnitude:n];
        _privateKey = [[RSAKey alloc] initWithGMPKey:d andMagnitude:n];
        
        mpz_clear(e);
        mpz_clear(n);
        mpz_clear(d);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super init])
    {
        _publicKey = [[coder decodeObjectForKey:(NSString*)kRSAKeyPair_publicKey] retain];
        _privateKey = [[coder decodeObjectForKey:(NSString*)kRSAKeyPair_privateKey] retain];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:_publicKey forKey:(NSString*)kRSAKeyPair_publicKey];
    [coder encodeObject:_privateKey forKey:(NSString*)kRSAKeyPair_privateKey];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@\n Public: %@\n Private: %@",
            [super description], _publicKey, _privateKey];
}

@end
