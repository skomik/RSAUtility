//
//  DropDestinationView.h
//  RSAUtility
//
//  Created by Sergey Olkhovnikov on 02.12.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DropDestinationView;

@protocol DropDestinationViewDelegate
- (void)destinationView:(DropDestinationView*) view selectedFile:(NSString*)filePath;
@end

@interface DropDestinationView : NSView <NSDraggingDestination>
{
    bool highlight;
    NSTextField* textField;
}

@property (nonatomic, assign) NSObject<DropDestinationViewDelegate>* delegate;

- (void)setInitialText:(NSString*)text;
- (void)reset;
- (BOOL)isFileSelected;

@end
