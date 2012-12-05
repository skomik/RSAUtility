//
//  DragAndDropController.m
//  RSAUtility
//
//  Created by Sergey Olkhovnikov on 02.12.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "DragAndDropController.h"
#import "DropDestinationView.h"

@interface DragAndDropController ()
@end

@implementation DragAndDropController

@synthesize startTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [startButton setEnabled:NO];
    [keyFileDestination setDelegate:self];
    [processedFileDestination setDelegate:self];
    
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:11];
    [consoleOutput setFont:font];
}

- (void)logString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    [consoleOutput setString:[consoleOutput.string stringByAppendingFormat:@"%@: %@\n", [formatter stringFromDate:[NSDate date]], string]];
}

- (IBAction)startButtonPressed:(id)sender
{
    [self startFileProcessing];
}

- (void)destinationView:(DropDestinationView *)view selectedFile:(NSURL *)fileURL
{
    //override this
}

- (void)startFileProcessing
{
    self.startTime = [NSDate date];
}

@end
