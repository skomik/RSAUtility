//
//  RSAKeyPair.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSAKey.h"

#define RSA_LENGTH 1024

@interface RSAKeyPair : NSObject
{
    RSAKey* _publicKey;
    RSAKey* _privateKey;
}

@property (readonly, retain) RSAKey* publicKey;
@property (readonly, retain) RSAKey* privateKey;

+ (RSAKeyPair*)randomPairWithLength:(int)length;

- (id)initRandomWithLength:(int)length;
- (id)initFromFile:(NSURL*)filePath;

- (void)saveToFile:(NSURL*)filePath;

@end
