//
//  CustomTokenFieldView.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"
#import "CustomTokenFieldView.h"

@implementation CustomTokenFieldView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
//    NSLog(@"%s: %@", __FUNCTION__, theEvent);
    
    [_viewController keyDown:theEvent];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
