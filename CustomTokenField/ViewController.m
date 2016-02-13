//
//  ViewController.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"
#import "CustomTokenFieldView.h"
#import "EditToken.h"
#import "Token.h"

@implementation ViewController {
    NSMutableArray<Token*> *_tokens;
    EditToken *_editToken;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _tokens = [NSMutableArray array];

    NSRect documentViewFrame = _scrollView.frame;
    documentViewFrame.size.width = CGFLOAT_MAX;
    
    NSView *documentView = [[CustomTokenFieldView alloc] initWithFrame:documentViewFrame];
    [_scrollView setDocumentView:documentView];
    
    [_tokens addObject:[Token createToken:@"Label1" viewController:self rect:NSMakeRect(0, 1, 44, documentView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Label2" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 44, documentView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Label3" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 44, documentView.frame.size.height-2)]];

    for(NSView *token in _tokens) {
        [documentView addSubview:token];
    }

    _editToken = [EditToken createEditToken:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 1, -4, CGFLOAT_MAX, documentView.frame.size.height)];
    
    [documentView addSubview:_editToken];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
}

- (void)textDidEndEditing:(NSNotification *)notification {
    
}

- (void)textDidBeginEditing:(NSNotification *)notification {
    
}

- (void)textDidChange:(NSNotification *)notification {
    
}

@end
