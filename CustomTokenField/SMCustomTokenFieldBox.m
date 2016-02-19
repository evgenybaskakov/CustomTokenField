//
//  SMBox.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/18/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "SMCustomTokenFieldBox.h"

@implementation SMCustomTokenFieldBox

static const NSUInteger cornerRadius = 4;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
    [[NSColor whiteColor] set];
    [path fill];
    
    if([self containsFirstResponder]) {
        NSSetFocusRingStyle(NSFocusRingBelow);
        
        NSBezierPath *focusRingPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
        [focusRingPath fill];
    }
    else {
        [[NSColor colorWithCalibratedWhite:0.85 alpha:1.0] set];
        [path stroke];
    }
}

- (BOOL)containsFirstResponder {
    NSMutableArray *array = [NSMutableArray arrayWithObject:self];
    
    while(array.count > 0) {
        NSView *nearestSubview = array.firstObject;
        
        if([[self window] firstResponder] == nearestSubview) {
            return YES;
        }
        
        [array addObjectsFromArray:nearestSubview.subviews];
        [array removeObjectAtIndex:0];
    }
    
    return NO;
}

@end
