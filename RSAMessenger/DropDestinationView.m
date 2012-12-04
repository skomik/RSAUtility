//
//  DropDestinationView.m
//  RSAUtility
//
//  Created by Sergey Olkhovnikov on 02.12.12.
//  Copyright (c) 2012 skomik. All rights reserved.
//

#import "DropDestinationView.h"

@interface DropDestinationView()
@property (nonatomic, retain) NSString* initialText;
- (void)setHighlighted:(BOOL)value;
@end

@implementation DropDestinationView

@synthesize initialText;
@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
        NSSize size = [self bounds].size;
        
        textField = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, size.width, 20)] autorelease];
        [textField setStringValue:@""];
        [textField setBezeled:NO];
        [textField setDrawsBackground:NO];
        [textField setEditable:NO];
        [textField setSelectable:NO];
        [textField setAlignment:NSCenterTextAlignment];
        [textField setTextColor:[[NSColor darkGrayColor] colorWithAlphaComponent:0.7]];
        [self addSubview:textField];
        
        NSFont* font = [NSFont fontWithName:@"Lucida Grande Bold" size:13];
        [textField setFont:font];
        
        //position label in center
        [textField setFrameOrigin:NSMakePoint(0, (size.height - 20)/2)];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)value
{
    highlight = value;
    [self setNeedsDisplay:YES];
}

- (void)setInitialText:(NSString*)text
{
    if (initialText)
        [initialText release];
    initialText = [text retain];
    [textField setStringValue:text];
}

- (void)reset
{
    [textField setTextColor:[[NSColor darkGrayColor] colorWithAlphaComponent:0.7]];
    [textField setStringValue:self.initialText];
}

- (BOOL)isFileSelected
{
    return ![textField.stringValue isEqualToString:self.initialText];
}

- (void)drawRect:(NSRect)dirtyRect
{    
    [super drawRect:dirtyRect];
    
    if (highlight)
        [[[NSColor blueColor] colorWithAlphaComponent:0.5] set];
    else
        [[[NSColor grayColor] colorWithAlphaComponent:0.5] set];
    
    const float lineWidth = 4;
    [NSBezierPath setDefaultLineWidth:lineWidth];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds], lineWidth/2, lineWidth/2)
                                                         xRadius:20
                                                         yRadius:20];
    [path stroke];
}

#pragma mark - NSDraggingDestination Protocol

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    [self setHighlighted:YES];
    return NSDragOperationGeneric;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    [self setHighlighted:NO];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    [self setHighlighted:NO];
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType])
    {
        NSArray *paths = [pboard propertyListForType:NSFilenamesPboardType];
        NSString *filename = [paths objectAtIndex:0];
        
        [textField setTextColor:[NSColor blackColor]];
        [textField setStringValue:[[filename componentsSeparatedByString:@"/"] lastObject]];
        
        if (delegate && [delegate respondsToSelector:@selector(destinationView:selectedFile:)])
            [delegate destinationView:self selectedFile:filename];
    }
    
    return YES;
}

#pragma mark -

@end
