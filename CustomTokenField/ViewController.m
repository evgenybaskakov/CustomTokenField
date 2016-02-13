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
    
    [_tokens addObject:[Token createToken:@"Label1" viewController:self rect:NSMakeRect(0, 1, 44, _tokenFieldView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Label2" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 44, _tokenFieldView.frame.size.height-2)]];
    [_tokens addObject:[Token createToken:@"Label3" viewController:self rect:NSMakeRect(((NSView*)_tokens.lastObject).frame.origin.x + ((NSView*)_tokens.lastObject).frame.size.width + 2, 1, 44, _tokenFieldView.frame.size.height-2)]];

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
    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
    _editingText = YES;
}

- (void)textDidBeginEditing:(NSNotification *)notification {
    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
    _editingText = NO;
}

- (void)textDidChange:(NSNotification *)notification {
//    NSLog(@"%s: %@", __FUNCTION__, notification.userInfo);
}

- (void)editToken:(EditToken*)sender {
    NSLog(@"%s", __FUNCTION__);
    _editingText = YES;
}

- (void)cursorLeftFrom:(EditToken*)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [_tokenFieldView.window makeFirstResponder:_tokenFieldView];
    [_selectedTokens removeAllIndexes];

    if(_tokens.count > 0) {
        _currentToken = _tokens.count-1;
        
        [_selectedTokens addIndex:_currentToken];
        
        for(Token *token in _tokens) {
            token.selected = NO;
        }
        
        _tokens[_currentToken].selected = YES;
        
        _editingText = NO;

        [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
    }
}

- (void)keyDown:(NSEvent *)theEvent {
    NSLog(@"%s: %@", __FUNCTION__, theEvent);
    
    if(!_editingText) {
        if(theEvent.keyCode == 123) {
            if(_currentToken > 0) {
                _tokens[_currentToken].selected = NO;
                _tokens[--_currentToken].selected = YES;

                [_selectedTokens removeAllIndexes];
                [_selectedTokens addIndex:_currentToken];

                [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
            }
        }
        else if(theEvent.keyCode == 124) {
            if(_currentToken >= 0 && _currentToken < _tokens.count-1) {
                _tokens[_currentToken].selected = NO;
                _tokens[++_currentToken].selected = YES;

                [_selectedTokens removeAllIndexes];
                [_selectedTokens addIndex:_currentToken];

                [_tokenFieldView scrollRectToVisible:_tokens[_currentToken].frame];
            }
            else if(_currentToken == _tokens.count-1) {
                _tokens[_currentToken].selected = NO;
                _currentToken = -1;

                [_selectedTokens removeAllIndexes];

                [_tokenFieldView.window makeFirstResponder:_editToken];
                [_editToken setSelectedRange:NSMakeRange(0, 0)];
            }
        }
    }
}

@end
