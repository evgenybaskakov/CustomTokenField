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
    documentViewFrame.size.width = 0;
    
    _tokenFieldView = [[CustomTokenFieldView alloc] initWithFrame:documentViewFrame];
    
    [_scrollView setDocumentView:_tokenFieldView];
    
    [_tokens addObject:[Token createToken:@"Token1" viewController:self]];
    [_tokens addObject:[Token createToken:@"Token2" viewController:self]];
    [_tokens addObject:[Token createToken:@"Token3" viewController:self]];
    [_tokens addObject:[Token createToken:@"Token4" viewController:self]];

    _editToken = [EditToken createEditToken:self];
    
    for(NSView *token in _tokens) {
        [_tokenFieldView addSubview:token];
    }
    
    [self adjustTokenFrames];

    [_tokenFieldView addSubview:_editToken];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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
//    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
    [self deleteSelectedTokens];
}

- (void)editToken:(EditToken*)sender {
//    NSLog(@"%s", __FUNCTION__);
}

- (void)cursorLeftFrom:(EditToken*)sender jumpToBeginning:(BOOL)jumpToBeginning extendSelection:(BOOL)extendSelection {
//    NSLog(@"%s", __FUNCTION__);
    
    [_tokenFieldView.window makeFirstResponder:_tokenFieldView];

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
            [_editToken setSelectedRange:NSMakeRange(0, 0)];
        }

        [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
        
        _extendingSelectionFromText = extendSelection;
    }
    else {
        [_tokenFieldView.window makeFirstResponder:_editToken];
        [_editToken setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (void)selectAll:(id)sender {
    [_selectedTokens addIndexesInRange:NSMakeRange(0, _tokens.count)];

    for(Token *token in _tokens) {
        token.selected = YES;
    }

    if(_tokens.count > 0) {
        _currentToken = 0;
    }

    _extendingSelectionFromText = YES;
    [_editToken setSelectedRange:NSMakeRange(0, _editToken.string.length)];
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
        [_editToken deleteToBeginningOfLine:self];
    }
    
    [self adjustTokenFrames];
    
    [_tokenFieldView.window makeFirstResponder:_editToken];
}

- (void)adjustTokenFrames {
    for(NSUInteger i = 0; i < _tokens.count; i++) {
        Token *token = _tokens[i];
        
        CGFloat xpos;
        
        if(i == 0) {
            xpos = 0;
        }
        else {
            Token *prevToken = (Token*)_tokens[i-1];
            xpos = prevToken.frame.origin.x + prevToken.frame.size.width + 2;
        }
        
        [token setFrame:NSMakeRect(xpos, 1, 48, _tokenFieldView.frame.size.height-2)];
    }

    CGFloat xpos;
    
    if(_tokens.count == 0) {
        xpos = 0;
    }
    else {
        Token *prevToken = (Token*)_tokens.lastObject;
        xpos = prevToken.frame.origin.x + prevToken.frame.size.width;
    }

    CGFloat delta = 10;
    if(xpos + _editToken.attributedString.size.width + delta < _scrollView.frame.size.width) {
        _editToken.textContainer.size = NSMakeSize(_scrollView.frame.size.width - xpos, _editToken.textContainer.size.height);
    }
    else {
        _editToken.textContainer.size = NSMakeSize(_editToken.attributedString.size.width + delta, _editToken.textContainer.size.height);
    }
    
    _editToken.frame = NSMakeRect(xpos, -4, _editToken.textContainer.size.width, _tokenFieldView.frame.size.height);
    
    _tokenFieldView.frame = NSMakeRect(_tokenFieldView.frame.origin.x, _tokenFieldView.frame.origin.y, xpos + _editToken.frame.size.width, _tokenFieldView.frame.size.height);
}

- (void)tokenMouseDown:(Token*)token event:(NSEvent *)theEvent {
    [self clearCursorSelection];
    
    _currentToken = [_tokens indexOfObject:token];
    
    token.selected = YES;
    
    [_selectedTokens addIndex:_currentToken];
    [_editToken setSelectedRange:NSMakeRange(0, 0)];
    [_tokenFieldView.window makeFirstResponder:_tokenFieldView];
}

@end
