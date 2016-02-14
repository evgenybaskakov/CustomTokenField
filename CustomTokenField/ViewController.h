//
//  ViewController.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EditToken;

@interface ViewController : NSViewController<NSTextViewDelegate>

@property IBOutlet NSScrollView *scrollView;

- (void)editToken:(EditToken*)sender;
- (void)cursorLeftFrom:(EditToken*)sender jumpToBeginning:(BOOL)jumpToBeginning extendSelection:(BOOL)extendSelection;
- (void)clearCursorSelection;

@end

