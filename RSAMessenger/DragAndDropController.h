//
//  DragAndDropController.h
//  RSAUtility
//
//  Created by Sergey Olkhovnikov on 02.12.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DropDestinationView.h"

@interface DragAndDropController : NSViewController <DropDestinationViewDelegate>
{
    IBOutlet DropDestinationView *keyFileDestination;
    IBOutlet DropDestinationView *processedFileDestination;
    
    IBOutlet NSButton *startButton;
    IBOutlet NSTextView *consoleOutput;
    IBOutlet NSProgressIndicator *progressIndicator;
}

@property (nonatomic, retain) NSDate* startTime;

- (void)startFileProcessing;
- (void)logString:(NSString*)string;

@end
