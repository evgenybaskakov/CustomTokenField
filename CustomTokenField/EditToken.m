//
//  EditToken.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "EditToken.h"
#import "ViewController.h"

@implementation EditToken {
    ViewController *__weak _viewController;
}

+ (EditToken*)createEditToken:(ViewController*)viewController {
    EditToken *editToken = [[EditToken alloc] initWithFrame:NSMakeRect(0, 0, 100, 100) viewController:viewController];

    editToken.focusRingType = NSFocusRingTypeNone;
    editToken.delegate = viewController;
    editToken.richText = NO;
    editToken.verticallyResizable = NO;
    editToken.importsGraphics = NO;
    editToken.textContainer.widthTracksTextView = NO;
    editToken.textContainer.containerSize = NSMakeSize(CGFLOAT_MAX, editToken.textContainer.containerSize.height);
    editToken.fieldEditor = YES;
    
    return editToken;
}

- (id)initWithFrame:(NSRect)frameRect viewController:(ViewController*)viewController {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        _viewController = viewController;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)becomeFirstResponder {
    [_viewController editToken:self];
    return YES;
}

- (void)paste:(id)sender {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSString *text = [pb stringForType:NSPasteboardTypeString];
    
    if(text != nil) {
        NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSString *oneLine = [lines componentsJoinedByString:@""];
        [self insertText:oneLine replacementRange:self.selectedRange];
    }
}

- (void)selectAll:(id)sender {
    [super selectAll:sender];
    
    [_viewController selectAll:self];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [_viewController clearCursorSelection];

    [super mouseDown:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent {
    BOOL commandKeyPressed = (theEvent.modifierFlags & NSCommandKeyMask) != 0;

    const NSUInteger codeLeft = 123, codeRight = 124, codeDelete = 51;
    
    if(theEvent.keyCode == codeLeft && (self.selectedRange.location == 0 || commandKeyPressed)) {
        BOOL extendSelection = (theEvent.modifierFlags & NSShiftKeyMask) != 0;

        [_viewController cursorLeftFrom:self jumpToBeginning:commandKeyPressed extendSelection:extendSelection];
    }
    else if(theEvent.keyCode == codeLeft || theEvent.keyCode == codeRight) { // TODO: add other movement keys
        BOOL extendSelection = (theEvent.modifierFlags & NSShiftKeyMask) != 0;
        
        if(theEvent.keyCode == codeLeft && !extendSelection && _viewController.tokenSelectionActive) {
            [_viewController clearCursorSelection];
            [_viewController cursorLeftFrom:self jumpToBeginning:commandKeyPressed extendSelection:NO];
        }
        else {
            if(!extendSelection) {
                [_viewController clearCursorSelection];
            }
            
            [super keyDown:theEvent];
        }
    }
    else if(theEvent.keyCode == codeDelete) {
        NSRange selection = self.selectedRange;

        if(selection.location == 0 && selection.length == 0) {
            [_viewController clearCursorSelection];
            [_viewController cursorLeftFrom:self jumpToBeginning:commandKeyPressed extendSelection:NO];
        }
        else if(selection.location == 0) {
            [_viewController deleteSelectedTokensAndText];
        }
        else {
            [super keyDown:theEvent];
        }
    }
    else {
        [super keyDown:theEvent];
    }
}

@end
