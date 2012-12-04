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
    
    //override this
//    [keyFileDestination setInitialText:@"Drop Key File Here"];
//    [processedFileDestination setInitialText:@"Drop File To Encrypt Here"];
//    [startButton setStringValue:@"Start"];
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
    //override this
}

@end
