//
//  GenerateViewController.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "GenerateViewController.h"
#import "RSAKeyPair.h"

@interface GenerateViewController ()

@end

@implementation GenerateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        RSAKeyPair *keyPair = [RSAKeyPair randomPairWithLength:RSA_LENGTH];
        NSLog(@"%@", keyPair);
    }
    
    return self;
}

@end
