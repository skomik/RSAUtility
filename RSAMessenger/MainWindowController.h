//
//  MainWindowController.h
//  RSAMessenger
//
//  Created by Sergey Olkhovnikov on 18.11.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GenerateViewController;
@class EncryptViewController;
@class DecryptViewController;

@interface MainWindowController : NSWindowController
{
    IBOutlet NSTabView *tabView;
}

@property (nonatomic, retain) EncryptViewController* encryptViewController;
@property (nonatomic, retain) DecryptViewController* decryptViewController;
@property (nonatomic, retain) GenerateViewController* generateViewController;

+ (void)showErrorAlert:(NSString*)message;

@end
