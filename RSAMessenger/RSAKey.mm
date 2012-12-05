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

const NSString* kRSAKey_chinese_p = @"kRSAKey_chinese_p";
const NSString* kRSAKey_chinese_q = @"kRSAKey_chinese_q";
const NSString* kRSAKey_chinese_dp = @"kRSAKey_chinese_dp";
const NSString* kRSAKey_chinese_dq = @"kRSAKey_chinese_dq";
const NSString* kRSAKey_chinese_pinv = @"kRSAKey_chinese_qpinv";
const NSString* kRSAKey_chinese_qinv = @"kRSAKey_chinese_qinv";

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
    
    if (supportsChineseRemainder)
    {
        delete _p;
        delete _q;
        delete _dp;
        delete _dq;
        delete _pinv;
        delete _qinv;
    }
    
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
    
    NSString* pStr = [coder decodeObjectForKey:(NSString*)kRSAKey_chinese_p];
    NSString* qStr = [coder decodeObjectForKey:(NSString*)kRSAKey_chinese_q];
    NSString* dpStr = [coder decodeObjectForKey:(NSString*)kRSAKey_chinese_dp];
    NSString* dqStr = [coder decodeObjectForKey:(NSString*)kRSAKey_chinese_dq];
    NSString* pinvStr = [coder decodeObjectForKey:(NSString*)kRSAKey_chinese_pinv];
    NSString* qinvStr = [coder decodeObjectForKey:(NSString*)kRSAKey_chinese_qinv];
    
    if (dpStr && dqStr && pinvStr && qinvStr)
    {
        supportsChineseRemainder = YES;
        
        _p = new mpz_class([pStr getSTLString]);
        _q = new mpz_class([qStr getSTLString]);
        _dp = new mpz_class([dpStr getSTLString]);
        _dq = new mpz_class([dqStr getSTLString]);
        _pinv= new mpz_class([pinvStr getSTLString]);
        _qinv= new mpz_class([qinvStr getSTLString]);
        
        [self logChineseElements];
    }
    
    return self;
}

- (void)setChineseRemainder_p:(mpz_t)p q:(mpz_t)q dp:(mpz_t)dp dq:(mpz_t)dq pinv:(mpz_t)pinv qinv:(mpz_t)qinv
{
    supportsChineseRemainder = YES;
    
    _p = new mpz_class(p);
    _q = new mpz_class(q);
    _dp = new mpz_class(dp);
    _dq = new mpz_class(dq);
    _pinv = new mpz_class(pinv);
    _qinv = new mpz_class(qinv);
    
    [self logChineseElements];
}

- (void)logChineseElements
{
    NSString* pStr = [NSString stringWithSTLString:_p->get_str()];
    NSString* qStr = [NSString stringWithSTLString:_q->get_str()];
    NSString* dpStr = [NSString stringWithSTLString:_dp->get_str()];
    NSString* dqStr = [NSString stringWithSTLString:_dq->get_str()];
    NSString* pinvStr = [NSString stringWithSTLString:_pinv->get_str()];
    NSString* qinvStr = [NSString stringWithSTLString:_qinv->get_str()];
    
    NSLog(@"p = %@", pStr);
    NSLog(@"q = %@", qStr);
    NSLog(@"dp = %@", dpStr);
    NSLog(@"dq = %@", dqStr);
    NSLog(@"pinv = %@", pinvStr);
    NSLog(@"qinv = %@", qinvStr);
}

- (int)processBytes:(char *)bytesToProcess length:(long)length toBytes:(char *)processedBytes mode:(int)mode
{
    bool encrypting = mode == MODE_ENCRYPT;
    
    mpz_t inputNumber, outputNumber;
    
    mpz_init(inputNumber);
    mpz_init(outputNumber);
    
    mpz_import(inputNumber, length, 1, sizeof(bytesToProcess[0]), 0, 0, bytesToProcess);
    
//    if (!supportsChineseRemainder)
//    {
        mpz_powm(outputNumber, inputNumber, _key->get_mpz_t(), _magnitude->get_mpz_t());
    logNumber(outputNumber);
//    }
//    else
    {
        // mp = c^dp (mod p)
        // mq = c^dq (moq q)
        // m1 = mp * pinv * q
        // m2 = mq * qinv * q
        // m  = m1 + m2 (mod n)
        
        mpz_t mp, mq, mp_mul_q, mq_mul_q, m1, m2, m1_plus_m2;
        
        mpz_init(mp);
        mpz_init(mq);
        mpz_init(mp_mul_q);
        mpz_init(mq_mul_q);
        mpz_init(m1);
        mpz_init(m2);
        mpz_init(m1_plus_m2);
        
        mpz_powm(mp, inputNumber, _dp->get_mpz_t(), _p->get_mpz_t());
        mpz_powm(mq, inputNumber, _dq->get_mpz_t(), _q->get_mpz_t());
        mpz_mul(mp_mul_q, mp, _q->get_mpz_t());
        mpz_mul(mq_mul_q, mq, _q->get_mpz_t());
        mpz_mul(m1, mp_mul_q, _pinv->get_mpz_t());
        mpz_mul(m2, mq_mul_q, _qinv->get_mpz_t());
        mpz_add(m1_plus_m2, m1, m2);
        mpz_tdiv_r(outputNumber, m1_plus_m2, _magnitude->get_mpz_t());
        
        logNumber(outputNumber);
        
        mpz_clear(mp);
        mpz_clear(mq);
        mpz_clear(mp_mul_q);
        mpz_clear(mq_mul_q);
        mpz_clear(m1);
        mpz_clear(m2);
        mpz_clear(m1_plus_m2);
        
//        // wikipedia method not working
//        // m1 = c^dp (mod p)
//        // m2 = c^dq (mod q)
//        // h  = qinv * (m1 - m2) (mod p)
//        // m  = m2 + (h * q)
//        
//        mpz_t m1, m2, h, m1_minus_m2, h_mul_q;
//        
//        mpz_init(m1);
//        mpz_init(m2);
//        mpz_init(h);
//        mpz_init(m1_minus_m2);
//        mpz_init(h_mul_q);
//        
//        mpz_powm(m1, inputNumber, _dp->get_mpz_t(), _p->get_mpz_t());
//        mpz_powm(m2, inputNumber, _dq->get_mpz_t(), _q->get_mpz_t());
//        mpz_sub(m1_minus_m2, m1, m2);
//        
//        if (mpz_cmp(m1, m2) < 0)
//            mpz_add(m1_minus_m2, m1_minus_m2, _p->get_mpz_t());
//        
//        mpz_mul(h, _qinv->get_mpz_t(), m1_minus_m2);
//        mpz_mul(h_mul_q, h, _q->get_mpz_t());
//        mpz_add(outputNumber, m2, h_mul_q);
//        
//        mpz_clear(m1);
//        mpz_clear(m2);
//        mpz_clear(h);
//        mpz_clear(m1_minus_m2);
//        mpz_clear(h_mul_q);
    }
    
    
    int maxLength = encrypting ? [self getBlockSize] : [self getBlockEncryptedBytesCount];
    int exportLength = (mpz_sizeinbase(outputNumber, BASE_2) + 8 - 1)/8;
    int offset = maxLength - exportLength;
    
    assert(offset >= 0);
    
    mpz_export(processedBytes + offset, NULL, 1, sizeof(char), 0, 0, outputNumber);
    
    mpz_clear(inputNumber);
    mpz_clear(outputNumber);
    
    return exportLength + offset;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:[self getKeyString] forKey:(NSString*)kRSAKey_key];
    [coder encodeObject:[self getMagnitudeString] forKey:(NSString*)kRSAKey_magnitude];
    [coder encodeInt:_rsa_length forKey:(NSString*)kRSAKey_rsa_length];
    
    if (supportsChineseRemainder)
    {
        [coder encodeObject:[NSString stringWithSTLString:_p->get_str()] forKey:(NSString*)kRSAKey_chinese_p];
        [coder encodeObject:[NSString stringWithSTLString:_q->get_str()] forKey:(NSString*)kRSAKey_chinese_q];
        [coder encodeObject:[NSString stringWithSTLString:_dp->get_str()] forKey:(NSString*)kRSAKey_chinese_dp];
        [coder encodeObject:[NSString stringWithSTLString:_dq->get_str()] forKey:(NSString*)kRSAKey_chinese_dq];
        [coder encodeObject:[NSString stringWithSTLString:_pinv->get_str()] forKey:(NSString*)kRSAKey_chinese_pinv];
        [coder encodeObject:[NSString stringWithSTLString:_qinv->get_str()] forKey:(NSString*)kRSAKey_chinese_qinv];
    }
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
