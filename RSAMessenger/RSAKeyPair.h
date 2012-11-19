//
//  RSAKeyPair.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAKey.h"

@interface RSAKeyPair : NSObject
{
    RSAKey* _publicKey;
    RSAKey* _privateKey;
}

@property (readonly, retain) RSAKey* publicKey;
@property (readonly, retain) RSAKey* privateKey;

+ (RSAKeyPair*)randomPairWithLength:(int)length;

- (id)initRandomWithLength:(int)length;
- (id)initWithCoder:(NSCoder*)coder;

- (void)encodeWithCoder:(NSCoder*)coder;

@end
