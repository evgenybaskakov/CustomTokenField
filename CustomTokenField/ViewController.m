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
    CustomTokenFieldView *_tokenFieldView;
    NSMutableArray<Token*> *_tokens;
    NSMutableIndexSet *_selectedTokens;
    NSInteger _currentToken;
    EditToken *_editToken;
    BOOL _extendingSelectionFromText;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _tokens = [NSMutableArray array];
    _selectedTokens = [NSMutableIndexSet indexSet];
    _currentToken = -1;

    NSRect documentViewFrame = _scrollView.frame;
    documentViewFrame.size.width = CGFLOAT_MAX;
    
    _tokenFieldView = [[CustomTokenFieldView alloc] initWithFrame:documentViewFrame];
    
    [_scrollView setDocumentView:_tokenFieldView];
    
    [_tokens addObject:[Token createToken:@"Token1" viewController:self rect:NSMakeRect(0, 1, 48, _tokenFieldView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Token2" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 48, _tokenFieldView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Token3" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 48, _tokenFieldView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Token4" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 48, _tokenFieldView.frame.size.height-2)]];

    for(NSView *token in _tokens) {
        [_tokenFieldView addSubview:token];
    }

    _editToken = [EditToken createEditToken:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width, -4, CGFLOAT_MAX, _tokenFieldView.frame.size.height)];
    
    [_tokenFieldView addSubview:_editToken];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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
//    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
}

- (void)editToken:(EditToken*)sender {
    NSLog(@"%s", __FUNCTION__);
}

- (void)cursorLeftFrom:(EditToken*)sender jumpToBeginning:(BOOL)jumpToBeginning extendSelection:(BOOL)extendSelection {
//    NSLog(@"%s", __FUNCTION__);
    
    [_tokenFieldView.window makeFirstResponder:_tokenFieldView];
    [_selectedTokens removeAllIndexes];

    if(_tokens.count > 0) {
        if(jumpToBeginning) {
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

                NSRange range = _editToken.selectedRange;
                [_editToken setSelectedRange:NSMakeRange(0, range.location + range.length)];
            }
        }
        else {
            [self clearCursorSelection];

            _currentToken = _tokens.count-1;
            
            [_selectedTokens addIndex:_currentToken];
            _tokens[_currentToken].selected = YES;
        }

        if(!extendSelection) {
            [_editToken setSelectedRange:NSMakeRange(0, 0)];
        }

        [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
        
        _extendingSelectionFromText = extendSelection;
    }
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
    
    if(theEvent.keyCode == 123) {
        NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
        BOOL extendSelection = (flags & NSShiftKeyMask) != 0;

        if(!extendSelection) {
            [self clearCursorSelection];
            
            if(_currentToken == 0) {
                _tokens[_currentToken].selected = YES;

                [_selectedTokens addIndex:_currentToken];
            }

            [_editToken setSelectedRange:NSMakeRange(0, 0)];
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
            else {
                _tokens[--_currentToken].selected = YES;
            }

            [_selectedTokens addIndex:_currentToken];

            [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
        }
    }
    else if(theEvent.keyCode == 124) {
        NSUInteger flags = theEvent.modifierFlags & NSDeviceIndependentModifierFlagsMask;
        BOOL extendSelection = (flags & NSShiftKeyMask) != 0;
        BOOL selectionWasExtendingFromText = _extendingSelectionFromText;
        
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

                [_tokenFieldView.window makeFirstResponder:_editToken];

                [_editToken setSelectedRange:NSMakeRange(0, _editToken.string.length)];
            }
            else {
                [self clearCursorSelection];
                
                [_tokenFieldView.window makeFirstResponder:_editToken];
                
                [_editToken setSelectedRange:NSMakeRange(_editToken.string.length, 0)];
            }
        }
        else {
            if(selectionWasExtendingFromText && !extendSelection) {
                NSRange range = _editToken.selectedRange;

                [_tokenFieldView.window makeFirstResponder:_editToken];
                [_editToken setSelectedRange:NSMakeRange(range.location + range.length, 0)];
            }
            else {
                if(_currentToken >= 0 && _currentToken < _tokens.count-1) {
                    _tokens[++_currentToken].selected = YES;

                    [_selectedTokens addIndex:_currentToken];

                    [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
                }
                else if(_currentToken == _tokens.count-1) {
                    [_tokenFieldView.window makeFirstResponder:_editToken];

                    if(!extendSelection) {
                        _currentToken = -1;
                        
                        [_editToken setSelectedRange:NSMakeRange(0, 0)];
                    }
                    else {
                        NSRange range = _editToken.selectedRange;
                        
                        if(range.length == 0) {
                            [_editToken setSelectedRange:NSMakeRange(0, 1)];
                        }
                        else {
                            [_editToken setSelectedRange:NSMakeRange(0, 0)];
                            [_editToken setSelectedRange:range];
                        }
                    }
                }
            }
        }
    }
}

@end
