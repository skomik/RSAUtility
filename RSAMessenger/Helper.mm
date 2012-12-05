//
//  Helper.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "Helper.h"
#import <CommonCrypto/CommonCrypto.h>

const NSString* kRSAMessengerWorkingDir = @"kRSAMessengerWorkingDir";

@implementation NSString (CPlus)

+ (NSString*)stringWithSTLString:(std::string)stdString
{
    return [NSString stringWithCString:stdString.c_str() encoding:NSUTF8StringEncoding];
}

- (std::string)getSTLString
{
    return std::string([self UTF8String]);
}

@end

@implementation NSView(DisableSubViews)

- (void)setSubViewsEnabled:(BOOL)enabled
{
    NSView* currentView = NULL;
    NSEnumerator* viewEnumerator = [[self subviews] objectEnumerator];
    
    while( currentView = [viewEnumerator nextObject] )
    {
        if( [currentView respondsToSelector:@selector(setEnabled:)] )
        {
            [(NSControl*)currentView setEnabled:enabled];
        }
        [currentView setSubViewsEnabled:enabled];
        
        [currentView display];
    }
}

@end

@implementation NSData (NSDataStrings)

- (NSString*)stringWithHexBytes
{
    const char* bytes = (char*)[self bytes];
    NSArray *hexDigits = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", nil];
    NSMutableString *string = [NSMutableString stringWithString:@""];
    unsigned char byte;
    for(int i = 0; i < [self length]; i++)
    {
        byte = bytes[i];
        [string appendString:[hexDigits objectAtIndex:(byte >> 4)]];
        [string appendString:[hexDigits objectAtIndex:(byte & 0x0F)]];
    }
    
    return string;
}

@end

@implementation Helper

+ (NSURL*)getWorkingDir
{
    NSString *workingDirString = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString*)kRSAMessengerWorkingDir];
    if (workingDirString)
        return [NSURL URLWithString:workingDirString];
    else
        return [NSURL fileURLWithPath:NSHomeDirectory()];
}

+ (void)setWorkingDir:(NSURL *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[value absoluteString] forKey:(NSString*)kRSAMessengerWorkingDir];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)sha1Hash:(NSData *)data
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    if (CC_SHA1([data bytes], (CC_LONG)[data length], digest))
    {
        NSData* hashData = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
        return [hashData stringWithHexBytes];
    }
    else
        return nil;
}

@end