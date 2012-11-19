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

@interface Helper : NSObject

+ (NSURL*)getWorkingDir;
+ (void)setWorkingDir:(NSURL*)value;

@end
