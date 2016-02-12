//
//  ViewController.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"

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
    
    [_labels addObject:[self createLabel:NSMakeRect(0, 1, 42, documentView.frame.size.height-3) text:@"Label1"]];
    [_labels addObject:[self createLabel:NSMakeRect(((NSView*)_labels.lastObject).frame.origin.x + ((NSView*)_labels.lastObject).frame.size.width + 2, 1, 42, documentView.frame.size.height-3) text:@"Label2"]];
    [_labels addObject:[self createLabel:NSMakeRect(((NSView*)_labels.lastObject).frame.origin.x + ((NSView*)_labels.lastObject).frame.size.width + 2, 1, 42, documentView.frame.size.height-3) text:@"Label3"]];

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

- (NSTextField*)createLabel:(NSRect)rect text:(NSString*)text {
    NSTextField *label = [[NSTextField alloc] initWithFrame:rect];
    
    label.focusRingType = NSFocusRingTypeNone;
    label.bordered = YES;
    label.backgroundColor = [NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    label.cell.wraps = NO;
    label.cell.usesSingleLineMode = YES;
    label.editable = NO;
    label.stringValue = text;
    label.wantsLayer = YES;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    [label setFont:[NSFont systemFontOfSize:11]];
    
    return label;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
