//
//  DropDestinationView.m
//  RSAUtility
//
//  Created by Sergey Olkhovnikov on 02.12.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "DropDestinationView.h"

@implementation DropDestinationView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    [super drawRect:dirtyRect];
    
    [[NSColor grayColor]set];
    [NSBezierPath setDefaultLineWidth:5];
    [NSBezierPath strokeRect:dirtyRect];
}

@end
