//
//  Helper.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "Helper.h"

@implementation NSString (CPlus)

+ (NSString*)stringWithSTLString:(std::string)stdString
{
    return [NSString stringWithCString:stdString.c_str() encoding:NSUTF8StringEncoding];
}

@end