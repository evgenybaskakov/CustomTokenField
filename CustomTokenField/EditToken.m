//
//  EditToken.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "EditToken.h"
#import "ViewController.h"

@implementation EditToken {
    ViewController *__weak _viewController;
}

+ (EditToken*)createEditToken:(ViewController*)viewController rect:(NSRect)rect {
    EditToken *editToken = [[EditToken alloc] initWithFrame:rect viewController:viewController];

    editToken.focusRingType = NSFocusRingTypeNone;
    editToken.delegate = viewController;
    editToken.richText = NO;
    editToken.verticallyResizable = NO;
    editToken.importsGraphics = NO;
    editToken.textContainer.widthTracksTextView = NO;
    editToken.textContainer.containerSize = NSMakeSize(CGFLOAT_MAX, editToken.textContainer.containerSize.height);
    editToken.fieldEditor = YES;
    
    return editToken;
}

- (id)initWithFrame:(NSRect)frameRect viewController:(ViewController*)viewController {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        _viewController = viewController;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)paste:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSString *text = [pb stringForType:NSPasteboardTypeString];
    
    if(text != nil) {
        NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSString *oneLine = [lines componentsJoinedByString:@""];
        [self insertText:oneLine replacementRange:self.selectedRange];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
    NSLog(@"%s: %@", __FUNCTION__, theEvent);
}

@end
