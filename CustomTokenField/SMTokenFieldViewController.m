//
//  SMViewController.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "SMTokenFieldViewController.h"
#import "SMTokenFieldView.h"
#import "SMTokenEditView.h"
#import "SMTokenView.h"

@implementation SMTokenFieldViewController {
    SMTokenFieldView *_tokenFieldView;
    NSMutableArray<SMTokenView*> *_tokens;
    NSMutableIndexSet *_selectedTokens;
    NSInteger _currentToken;
    SMTokenEditView *_mainTokenEditor;
    SMTokenEditView *_existingTokenEditor;
    BOOL _extendingSelectionFromText;
    SMTokenView *_tokenWithMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _tokens = [NSMutableArray array];
    _selectedTokens = [NSMutableIndexSet indexSet];
    _currentToken = -1;

    NSRect documentViewFrame = _scrollView.frame;
    documentViewFrame.size.width = 0;
    
    _tokenFieldView = [[SMTokenFieldView alloc] initWithFrame:documentViewFrame];
    
    [_scrollView setDocumentView:_tokenFieldView];
    
    _mainTokenEditor = [SMTokenEditView createEditToken:self];
    [_tokenFieldView addSubview:_mainTokenEditor];

    [self adjustTokenFrames];
    
    [self testSetup];
}

- (void)testSetup {
    [self addToken:@"Token1" contentsText:@"Blah!!" target:self selector:@selector(tokenAction:)];
    [self addToken:@"Token2" contentsText:@"Foo" target:self selector:@selector(tokenAction:)];
    [self addToken:@"Token3" contentsText:@"Bar" target:self selector:@selector(tokenAction:)];
    [self addToken:@"Token4" contentsText:@"Everything's weird" target:self selector:@selector(tokenAction:)];
    
    _target = self;
    _action = @selector(testAction:);
    _actionDelay = 0.2;
}

- (void)testAction:(id)sender {
    NSLog(@"token field action triggered");
}

- (void)tokenAction:(id)sender {
    NSAssert([sender isKindOfClass:[SMTokenView class]], @"unexpected sender");
    SMTokenView *token = sender;
    
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    _tokenWithMenu = token;
    
    [[theMenu addItemWithTitle:@"Edit" action:@selector(editTokenWithMenu:) keyEquivalent:@""] setTarget:self];
    [theMenu addItemWithTitle:@"Delete" action:@selector(blah:) keyEquivalent:@""];
    
    [theMenu popUpMenuPositioningItem:nil atLocation:NSMakePoint(0, -6) inView:token];
}

- (void)blah:(id)sender {
    NSLog(@"Blah!");
}

- (void)editTokenWithMenu:(id)sender {
    [self editToken:_tokenWithMenu];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)addToken:(NSString*)tokenName contentsText:(NSString*)contentsText target:(id)target selector:(SEL)selector {
    SMTokenView *token = [SMTokenView createToken:tokenName contentsText:contentsText target:target selector:selector viewController:self];
    
    [_tokens addObject:token];
    [_tokenFieldView addSubview:token];

    [self adjustTokenFrames];
}

- (void)changeToken:(SMTokenView*)tokenView tokenName:(NSString*)tokenName contentsText:(NSString*)contentsText representedObject:(NSObject*)representedObject target:(id)target selector:(SEL)selector {
    
    NSUInteger idx = [_tokens indexOfObject:tokenView];
    if(idx == NSNotFound) {
        NSLog(@"token '%@' not found", tokenView.tokenName);
        return;
    }
    
    [_tokens[idx] removeFromSuperview];
    
    SMTokenView *newTokenView = [SMTokenView createToken:tokenName contentsText:contentsText target:target selector:selector viewController:self];
    
    _tokens[idx] = newTokenView;
    
    [_tokenFieldView addSubview:newTokenView];
    
    if(tokenView.selected) {
        newTokenView.selected = YES;
    }
    
    [self adjustTokenFrames];
}

- (void)editToken:(SMTokenView*)token {
    NSUInteger idx = [_tokens indexOfObject:token];
    NSAssert(idx != NSNotFound, @"token %@ not found", token.tokenName);
    
    [token removeFromSuperview];
    [_selectedTokens removeIndex:idx];
    if(_currentToken == idx) {
        _currentToken = -1;
    }
    
    NSAssert(_existingTokenEditor == nil, @"_existingTokenEditor == nil"); // TODO
    
    _existingTokenEditor = [SMTokenEditView createEditToken:self];
    [_existingTokenEditor setString:token.contentsText];

    [_tokenFieldView addSubview:_existingTokenEditor];
    [_tokenFieldView.window makeFirstResponder:_existingTokenEditor];
    
    _existingTokenEditor.parentToken = token;
    token.editorView = _existingTokenEditor;
    
    [self adjustTokenFrames];
}

- (void)stopTokenEditing:(BOOL)clearEditedTokenSelection {
    NSAssert(_existingTokenEditor != nil, @"_existingTokenEditor == nil");
    
    SMTokenView *token = _existingTokenEditor.parentToken;
    NSAssert(token != nil, @"parent token is nil");
    
    NSUInteger idx = [_tokens indexOfObject:token];
    NSAssert(idx != NSNotFound, @"edited token not found");
    
    [_existingTokenEditor removeFromSuperview];
    
    NSString *newTokenString = _existingTokenEditor.string;
    if(![newTokenString isEqualToString:token.contentsText]) {
//        if(newTokenString.length > 0) {
        [self changeToken:token tokenName:token.tokenName contentsText:newTokenString representedObject:/*TODO*/nil target:token.target selector:token.selector];
        token = nil;
//        }
//        else {
            // TODO
//        }
    }
    else {
        [_tokenFieldView addSubview:token];
        token.editorView = nil;
    }
    
    _existingTokenEditor = nil;
    
    [_tokenFieldView.window makeFirstResponder:_tokenFieldView];
    
    if(clearEditedTokenSelection) {
        _tokens[idx].selected = NO;
        [_selectedTokens removeIndex:idx];
    }

    [self adjustTokenFrames];
    
    // TODO: trigger change token content action if any
}

- (BOOL)tokenSelectionActive {
    return _selectedTokens.count > 0;
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
//    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
}

- (void)textDidEndEditing:(NSNotification *)notification {
//    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
}

- (void)textDidBeginEditing:(NSNotification *)notification {
//    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
}

- (void)textDidChange:(NSNotification *)notification {
    if(notification.object == _mainTokenEditor) {
        [self deleteSelectedTokens];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:_target selector:_action object:self];
        [_target performSelector:_action withObject:self afterDelay:_actionDelay];
    }
    else {
        // The notified editor is a token being edited.
        // So trigger no action, just update the environment.
        [self adjustTokenFrames];
    }
}

- (void)cursorLeftFrom:(SMTokenEditView*)sender jumpToBeginning:(BOOL)jumpToBeginning extendSelection:(BOOL)extendSelection {
//    NSLog(@"%s", __FUNCTION__);
    
    NSAssert(sender == _mainTokenEditor || sender == _existingTokenEditor, @"unknown sender");
    
    if(sender == _mainTokenEditor) {
        [_tokenFieldView.window makeFirstResponder:_tokenFieldView];

        if(_tokens.count > 0) {
            if(jumpToBeginning) {
                if(sender == _mainTokenEditor) {
                    if(!extendSelection) {
                        [self clearCursorSelection];
                        
                        _currentToken = 0;

                        [_selectedTokens addIndex:_currentToken];
                        _tokens[_currentToken].selected = YES;
                    }
                    else {
                        for(NSInteger i = 0; i < _tokens.count; i++) {
                            [_selectedTokens addIndex:i];

                            _tokens[i].selected = YES;
                        }
                        
                        _currentToken = 0;

                        NSRange range = _mainTokenEditor.selectedRange;
                        [_mainTokenEditor setSelectedRange:NSMakeRange(0, range.location + range.length)];
                    }
                }
                else {
                    
                }
            }
            else if(!extendSelection && _selectedTokens.count > 1) {
                NSInteger firstToken = _selectedTokens.firstIndex;
                
                [self clearCursorSelection];
                
                _currentToken = firstToken;
                
                [_selectedTokens addIndex:_currentToken];
                _tokens[_currentToken].selected = YES;
            }
            else {
                [self clearCursorSelection];

                _currentToken = _tokens.count-1;
                
                [_selectedTokens addIndex:_currentToken];
                _tokens[_currentToken].selected = YES;
            }

            if(!extendSelection) {
                [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
            }

            [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
            
            _extendingSelectionFromText = extendSelection;
        }
        else {
            [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];
            [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
        }
    }
    else {
        NSUInteger tokenIdx = [_tokens indexOfObject:sender.parentToken];
        NSAssert(tokenIdx != NSNotFound, @"edited token not found");
        
        if(tokenIdx > 0) {
            [self clearCursorSelection];

            if(jumpToBeginning) {
                if(!extendSelection) {
                    _currentToken = 0;
                    
                    [_selectedTokens addIndex:_currentToken];
                    _tokens[_currentToken].selected = YES;
                }
                else {
                    for(NSInteger i = 0; i < tokenIdx; i++) {
                        [_selectedTokens addIndex:i];
                        _tokens[i].selected = YES;
                    }
                    
                    _currentToken = 0;
                }
            }
            else {
                _currentToken = tokenIdx - 1;
                
                [_selectedTokens addIndex:_currentToken];
                _tokens[_currentToken].selected = YES;
            }
            
            [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];

            [self stopTokenEditing:YES];
        }
    }
}

- (void)cursorRightFrom:(SMTokenEditView*)sender jumpToEnd:(BOOL)jumpToEnd extendSelection:(BOOL)extendSelection {
    NSAssert(sender == _mainTokenEditor || sender == _existingTokenEditor, @"unknown sender");
    
    if(sender == _mainTokenEditor) {
        // Nothing to do.
    }
    else {
        NSUInteger tokenIdx = [_tokens indexOfObject:sender.parentToken];
        NSAssert(tokenIdx != NSNotFound, @"edited token not found");
        
        [self clearCursorSelection];

        if(tokenIdx + 1 < _tokens.count) {
            _currentToken = tokenIdx + 1;
            
            [_selectedTokens addIndex:_currentToken];
            _tokens[_currentToken].selected = YES;

            [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
        }
        
        [self stopTokenEditing:YES];
        
        if(tokenIdx + 1 == _tokens.count) {
            [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];
            [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
            
            _currentToken = -1;
        }
    }
}

- (void)selectAll:(id)sender {
    [_selectedTokens addIndexesInRange:NSMakeRange(0, _tokens.count)];

    for(SMTokenView *token in _tokens) {
        token.selected = YES;
    }

    if(_tokens.count > 0) {
        _currentToken = 0;
    }

    _extendingSelectionFromText = YES;
    [_mainTokenEditor setSelectedRange:NSMakeRange(0, _mainTokenEditor.string.length)];
}

- (void)clearCursorSelection {
    [_selectedTokens enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        _tokens[idx].selected = NO;
    }];
    
    [_selectedTokens removeAllIndexes];

    _extendingSelectionFromText = NO;
}

- (void)keyDown:(NSEvent *)theEvent {
//    NSLog(@"%s: %@", __FUNCTION__, theEvent);

    const NSUInteger codeLeft = 123, codeRight = 124, codeDelete = 51, codeForwardDelete = 117;
    
    if(theEvent.keyCode == codeLeft) { // Left
        NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
        BOOL extendSelection = (flags & NSShiftKeyMask) != 0;
        BOOL selectionWasExtendingFromText = _extendingSelectionFromText;
        NSUInteger oldSelectionLen = _selectedTokens.count;
        NSInteger oldFirstToken = (oldSelectionLen > 0? _selectedTokens.firstIndex : -1);

        if(!extendSelection) {
            [self clearCursorSelection];
            
            if(_currentToken == 0) {
                _tokens[_currentToken].selected = YES;

                [_selectedTokens addIndex:_currentToken];
            }

            [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
        }
        else {
            if(theEvent.modifierFlags & NSCommandKeyMask) {
                while(_selectedTokens.count > 1 && _currentToken == _selectedTokens.lastIndex) {
                    _tokens[_currentToken].selected = NO;
                    [_selectedTokens removeIndex:_currentToken];

                    _currentToken--;
                }
            }
            else {
                if(_selectedTokens.count > 1 && _currentToken == _selectedTokens.lastIndex) {
                    _tokens[_currentToken].selected = NO;
                    [_selectedTokens removeIndex:_currentToken];
                }
            }
        }

        if(_currentToken > 0) {
            if(theEvent.modifierFlags & NSCommandKeyMask) {
                while(_currentToken > 0) {
                    if(extendSelection) {
                        _tokens[_currentToken].selected = YES;
                        [_selectedTokens addIndex:_currentToken];
                    }
                    else {
                        _tokens[_currentToken].selected = NO;
                        [_selectedTokens removeIndex:_currentToken];
                    }

                    _currentToken--;
                }
                
                _tokens[_currentToken].selected = YES;
            }
            else if(!extendSelection && (oldSelectionLen > 1 || selectionWasExtendingFromText)) {
                _currentToken = oldFirstToken;
                _tokens[_currentToken].selected = YES;
            }
            else {
                _tokens[--_currentToken].selected = YES;
            }

            [_selectedTokens addIndex:_currentToken];
            [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
        }
    }
    else if(theEvent.keyCode == codeRight) { // Right
        NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
        BOOL extendSelection = (flags & NSShiftKeyMask) != 0;
        BOOL selectionWasExtendingFromText = _extendingSelectionFromText;
        NSUInteger oldSelectionLen = _selectedTokens.count;
        NSInteger oldLastToken = (oldSelectionLen > 0? _selectedTokens.lastIndex : -1);
        
        if(!extendSelection) {
            [self clearCursorSelection];
        }
        else {
            if(theEvent.modifierFlags & NSCommandKeyMask) {
                while(_selectedTokens.count > 1 && _currentToken == _selectedTokens.firstIndex) {
                    _tokens[_currentToken].selected = NO;
                    [_selectedTokens removeIndex:_currentToken];
                    
                    _currentToken++;
                }
            }
            else {
                if(_selectedTokens.count > 1 && _currentToken == _selectedTokens.firstIndex) {
                    _tokens[_currentToken].selected = NO;
                    [_selectedTokens removeIndex:_currentToken];
                }
            }
        }

        if(theEvent.modifierFlags & NSCommandKeyMask) {
            if(extendSelection) {
                for(NSInteger i = _currentToken; i < _tokens.count; i++) {
                    _tokens[i].selected = YES;
                    
                    [_selectedTokens addIndex:i];
                }
                
                _currentToken = _tokens.count-1;
                [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];

                [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];

                NSRange selectedRange = NSMakeRange(0, _mainTokenEditor.string.length);

                [_mainTokenEditor setSelectedRange:selectedRange];
                [_mainTokenEditor scrollRangeToVisible:selectedRange];
            }
            else {
                [self clearCursorSelection];
                
                [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];
                
                NSRange selectedRange = NSMakeRange(_mainTokenEditor.string.length, 0);
                
                [_mainTokenEditor setSelectedRange:selectedRange];
                [_mainTokenEditor scrollRangeToVisible:selectedRange];
            }
        }
        else {
            if(selectionWasExtendingFromText && !extendSelection) {
                NSRange range = _mainTokenEditor.selectedRange;

                [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];
                [_mainTokenEditor setSelectedRange:NSMakeRange(range.location + range.length, 0)];
            }
            else {
                if(!extendSelection && oldSelectionLen > 1) {
                    _currentToken = oldLastToken;
                    _tokens[_currentToken].selected = YES;
                    [_selectedTokens addIndex:_currentToken];
                    [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
                }
                else if(_currentToken >= 0 && _currentToken < _tokens.count-1) {
                    _tokens[++_currentToken].selected = YES;
                    [_selectedTokens addIndex:_currentToken];
                    [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
                }
                else if(_currentToken == _tokens.count-1) {
                    [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];

                    if(!extendSelection) {
                        _currentToken = -1;
                        
                        [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
                    }
                    else {
                        NSRange range = _mainTokenEditor.selectedRange;
                        
                        if(range.length == 0) {
                            [_mainTokenEditor setSelectedRange:NSMakeRange(0, 1)];
                        }
                        else {
                            [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
                            [_mainTokenEditor setSelectedRange:range];
                        }
                    }
                }
            }
        }
    }
    else {
        if(theEvent.keyCode == codeDelete || theEvent.keyCode == codeForwardDelete) {
            [self deleteSelectedTokensAndText];
        }
        else {
            [super keyDown:theEvent];
        }
    }
}

- (void)deleteSelectedTokens {
    [self deleteSelectedTokensAndText:NO];
}

- (void)deleteSelectedTokensAndText {
    [self deleteSelectedTokensAndText:YES];
}

- (void)deleteSelectedTokensAndText:(BOOL)deleteText {
    [_selectedTokens enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [_tokens[idx] removeFromSuperview];
    }];
    
    [_tokens removeObjectsAtIndexes:_selectedTokens];
    [_selectedTokens removeAllIndexes];
    _currentToken = -1;
    
    if(deleteText) {
        [_mainTokenEditor deleteToBeginningOfLine:self];
    }
    
    [self adjustTokenFrames];
    
    [_tokenFieldView.window makeFirstResponder:_mainTokenEditor];
}

- (void)adjustTokenFrames {
    for(NSUInteger i = 0; i < _tokens.count; i++) {
        SMTokenView *token = _tokens[i];
        
        CGFloat xpos;
        
        if(i == 0) {
            xpos = 0;
        }
        else {
            SMTokenView *prevToken = _tokens[i-1];
            
            if(prevToken.editorView != nil) {
                xpos = prevToken.editorView.frame.origin.x + prevToken.editorView.frame.size.width + 4;
            }
            else {
                xpos = prevToken.frame.origin.x + prevToken.frame.size.width + 4;
            }
        }
        
        if(token.editorView != nil) {
            CGFloat leftDelta = 3;
            CGFloat rightDelta = 7;
            [token.editorView setFrame:NSMakeRect(xpos - leftDelta, 1, token.editorView.attributedString.size.width + rightDelta, 15)];
        }
        else {
            [token setFrame:NSMakeRect(xpos, 2, token.frame.size.width, token.frame.size.height)];
        }
    }

    CGFloat xpos;
    
    if(_tokens.count == 0) {
        xpos = 0;
    }
    else {
        SMTokenView *prevToken = _tokens.lastObject;

        if(prevToken.editorView != nil) {
            xpos = prevToken.editorView.frame.origin.x + prevToken.editorView.frame.size.width + 1;
        }
        else {
            xpos = prevToken.frame.origin.x + prevToken.frame.size.width + 1;
        }
    }

    CGFloat delta = 10;
    if(xpos + _mainTokenEditor.attributedString.size.width + delta < _scrollView.frame.size.width) {
        _mainTokenEditor.textContainer.size = NSMakeSize(_scrollView.frame.size.width - xpos, _mainTokenEditor.textContainer.size.height);
    }
    else {
        _mainTokenEditor.textContainer.size = NSMakeSize(_mainTokenEditor.attributedString.size.width + delta, _mainTokenEditor.textContainer.size.height);
    }
    
    _mainTokenEditor.frame = NSMakeRect(xpos, 1, _mainTokenEditor.textContainer.size.width, 15);
    
    _tokenFieldView.frame = NSMakeRect(_tokenFieldView.frame.origin.x, _tokenFieldView.frame.origin.y, xpos + _mainTokenEditor.frame.size.width, _tokenFieldView.frame.size.height);
}

- (void)tokenMouseDown:(SMTokenView*)token event:(NSEvent *)theEvent {
    [self clearCursorSelection];
    
    if(_existingTokenEditor != nil) {
        [self stopTokenEditing:YES];
    }
    
    _currentToken = [_tokens indexOfObject:token];
    
    token.selected = YES;
    
    [_selectedTokens addIndex:_currentToken];
    [_mainTokenEditor setSelectedRange:NSMakeRange(0, 0)];
    [_tokenFieldView.window makeFirstResponder:_tokenFieldView];
    [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
 
    // Force display in order to redraw the view if it just becomes 
    // the first responder and may need to refresh the graphics state.
    [self.view display];
}

- (void)clickWithinTokenEditor:(SMTokenEditView*)tokenEditor {
    [self clearCursorSelection];
    
    if(tokenEditor == _mainTokenEditor && _existingTokenEditor != nil) {
        [self stopTokenEditing:YES];
    }
}

@end
