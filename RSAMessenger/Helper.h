//
//  Helper.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 17.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <string>

@interface NSString (CPlus)
+ (NSString*)stringWithSTLString:(std::string)stdString;
- (std::string)getSTLString;
@end

@interface NSView(DisableSubViews)
- (void)setSubViewsEnabled:(BOOL)enabled;
@end

@interface NSData (NSDataStrings)
- (NSString*)stringWithHexBytes;
@end

@interface Helper : NSObject

+ (NSURL*)getWorkingDir;
+ (void)setWorkingDir:(NSURL*)value;
+ (NSString*)sha1Hash:(NSData*)data;

@end
