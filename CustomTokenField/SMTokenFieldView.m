//
//  SMCustomTokenFieldView.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "SMTokenFieldViewController.h"
#import "SMTokenFieldView.h"

@implementation SMTokenFieldView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)keyDown:(NSEvent *)theEvent {
    [super keyDown:theEvent];
    
//    NSLog(@"%s: %@", __FUNCTION__, theEvent);
    
    [_viewController keyDown:theEvent];
}

@end
