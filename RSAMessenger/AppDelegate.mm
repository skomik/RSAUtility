//
//  AppDelegate.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "AppDelegate.h"
#import "RSAKeyPair.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    RSAKeyPair* pair = [RSAKeyPair randomPairWithLength:1024];
    
    NSLog(@"Key pair: %@", pair);
}

@end
