//
//  ViewController.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"
#import "Token.h"

@implementation ViewController {
    NSMutableArray *_labels;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _labels = [NSMutableArray array];

    NSRect documentViewFrame = _scrollView.frame;
    documentViewFrame.size.width *= 2;
    
    NSView *documentView = [[NSView alloc] initWithFrame:documentViewFrame];
    [_scrollView setDocumentView:documentView];
    
    [_labels addObject:[Token createToken:@"Label1" viewController:self rect:NSMakeRect(0, 1, 44, documentView.frame.size.height-2)]];
    [_labels addObject:[Token createToken:@"Label2" viewController:self rect:NSMakeRect(((NSView*)_labels.lastObject).frame.origin.x + ((NSView*)_labels.lastObject).frame.size.width + 2, 1, 44, documentView.frame.size.height-2)]];
    [_labels addObject:[Token createToken:@"Label3" viewController:self rect:NSMakeRect(((NSView*)_labels.lastObject).frame.origin.x + ((NSView*)_labels.lastObject).frame.size.width + 2, 1, 44, documentView.frame.size.height-2)]];

    for(NSView *label in _labels) {
        [documentView addSubview:label];
    }

    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(((NSView*)_labels.lastObject).frame.origin.x + ((NSView*)_labels.lastObject).frame.size.width + 1, -2, CGFLOAT_MAX, documentView.frame.size.height)];
    
    textField.focusRingType = NSFocusRingTypeNone;
    textField.bordered = NO;
    textField.placeholderString = @"Search";
    textField.preferredMaxLayoutWidth = CGFLOAT_MAX;
    textField.cell.wraps = NO;
    textField.cell.usesSingleLineMode = YES;
    
    [documentView addSubview:textField];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
