//
//  Token.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"
#import "Token.h"

@implementation Token {
    ViewController *__weak _viewController;
}

+ (Token*)createToken:(NSString*)text viewController:(ViewController*)viewController rect:(NSRect)rect {
    Token *token = [[Token alloc] initWithFrame:rect viewController:viewController];
    
    token.focusRingType = NSFocusRingTypeNone;
    token.bezeled = YES;
    token.backgroundColor = [NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    token.cell.wraps = NO;
    token.cell.usesSingleLineMode = YES;
    token.editable = NO;
    token.stringValue = text;
//    token.wantsLayer = YES;
    token.layer.cornerRadius = 5;
    token.layer.masksToBounds = YES;
    [token setFont:[NSFont systemFontOfSize:11]];
    
    return token;
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

@end
