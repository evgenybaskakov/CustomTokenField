//
//  ViewController.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Token;
@class EditToken;

@interface ViewController : NSViewController<NSTextViewDelegate>

@property IBOutlet NSScrollView *scrollView;

@property (readonly) BOOL tokenSelectionActive;

- (void)editToken:(EditToken*)sender;
- (void)cursorLeftFrom:(EditToken*)sender jumpToBeginning:(BOOL)jumpToBeginning extendSelection:(BOOL)extendSelection;
- (void)clearCursorSelection;
- (void)tokenMouseDown:(Token*)token event:(NSEvent *)theEvent;
- (void)deleteSelectedTokensAndText;

@end

