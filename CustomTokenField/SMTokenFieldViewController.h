//
//  SMViewController.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMTokenView;
@class SMTokenEditView;

@interface SMTokenFieldViewController : NSViewController<NSTextViewDelegate>

@property IBOutlet NSScrollView *scrollView;

@property (readonly) BOOL tokenSelectionActive;

@property id target;
@property SEL action;
@property NSTimeInterval actionDelay;

- (void)addToken:(NSString*)tokenName contentsText:(NSString*)contentsText target:(id)target selector:(SEL)selector;
- (void)editToken:(SMTokenView*)token;
- (void)cursorLeftFrom:(SMTokenEditView*)sender jumpToBeginning:(BOOL)jumpToBeginning extendSelection:(BOOL)extendSelection;
- (void)cursorRightFrom:(SMTokenEditView*)sender jumpToEnd:(BOOL)jumpToEnd extendSelection:(BOOL)extendSelection;
- (void)clearCursorSelection;
- (void)tokenMouseDown:(SMTokenView*)token event:(NSEvent *)theEvent;
- (void)deleteSelectedTokensAndText;

@end

