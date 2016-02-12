//
//  ViewController.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSView *documentView = [[NSView alloc] initWithFrame:_scrollView.frame];
    [_scrollView setDocumentView:documentView];
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, -2, CGFLOAT_MAX, documentView.frame.size.height)];
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
