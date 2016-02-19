//
//  SMBox.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/18/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "SMCustomTokenFieldBox.h"

@implementation SMCustomTokenFieldBox

static const NSUInteger cornerRadius = 5;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
    [[NSColor whiteColor] set];
    [path fill];
    
    [[NSColor colorWithCalibratedWhite:0.89 alpha:1.0] set];
    [path stroke];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)drawFocusRingMask {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
    [path fill];
}

- (NSRect)focusRingMaskBounds {
    return [self bounds];
}

@end
