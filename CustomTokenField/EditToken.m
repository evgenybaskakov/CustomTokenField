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
    EditToken *textField = [[EditToken alloc] initWithFrame:rect viewController:viewController];
    
    textField.focusRingType = NSFocusRingTypeNone;
    textField.bordered = NO;
    textField.placeholderString = @"Search";
    textField.preferredMaxLayoutWidth = CGFLOAT_MAX;
    textField.cell.wraps = NO;
    textField.cell.usesSingleLineMode = YES;
    
    return textField;
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
