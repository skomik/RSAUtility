//
//  Helper.m
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "Helper.h"

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

@end