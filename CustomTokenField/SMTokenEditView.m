//
//  SMEditToken.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "SMTokenEditView.h"
#import "SMTokenFieldViewController.h"

@implementation SMTokenEditView {
    SMTokenFieldViewController *__weak _viewController;
}

+ (SMTokenEditView*)createEditToken:(SMTokenFieldViewController*)viewController {
    SMTokenEditView *editToken = [[SMTokenEditView alloc] initWithFrame:NSMakeRect(0, 0, NSUIntegerMax, 100) viewController:viewController];

    editToken.focusRingType = NSFocusRingTypeNone;
    editToken.delegate = viewController;
    editToken.richText = NO;
    editToken.horizontallyResizable = YES;
    editToken.verticallyResizable = NO;
    editToken.importsGraphics = NO;
    editToken.textContainer.widthTracksTextView = NO;
    editToken.fieldEditor = YES;
    editToken.drawsBackground = NO;
    
    return editToken;
}

- (id)initWithFrame:(NSRect)frameRect viewController:(SMTokenFieldViewController*)viewController {
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
    [_viewController.view display];
    [self setSelectedRange:NSMakeRange(0, 0)];
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
    [_viewController clickWithinTokenEditor:self];

    [super mouseDown:theEvent];
}

- (void)keyDown:(NSEvent *)theEvent {
    BOOL commandKeyPressed = (theEvent.modifierFlags & NSCommandKeyMask) != 0;

    const NSUInteger codeLeft = 123, codeRight = 124, codeDelete = 51, codeForwardDelete = 117;
    
    if(theEvent.keyCode == codeLeft && self.selectedRange.location > 0) {
        [super keyDown:theEvent];
    }
    else if(theEvent.keyCode == codeLeft && (self.selectedRange.location == 0 || commandKeyPressed)) {
        BOOL extendSelection = (theEvent.modifierFlags & NSShiftKeyMask) != 0;

        [_viewController cursorLeftFrom:self jumpToBeginning:commandKeyPressed extendSelection:extendSelection];
    }
    else if(theEvent.keyCode == codeLeft || theEvent.keyCode == codeRight) {
        BOOL extendSelection = (theEvent.modifierFlags & NSShiftKeyMask) != 0;
        NSRange selection = self.selectedRange;
        
        if(theEvent.keyCode == codeLeft && !extendSelection && _viewController.tokenSelectionActive) {
            [_viewController clearCursorSelection];
            [_viewController cursorLeftFrom:self jumpToBeginning:commandKeyPressed extendSelection:NO];
        }
        else {
            if(!extendSelection) {
                [_viewController clearCursorSelection];
            }
            
            if(theEvent.keyCode == codeRight && selection.location + selection.length == self.string.length) {
                [_viewController cursorRightFrom:self jumpToEnd:commandKeyPressed extendSelection:extendSelection];
            }
            else {
                [super keyDown:theEvent];
            }
        }
    }
    else if(theEvent.keyCode == codeDelete || (theEvent.keyCode == codeForwardDelete && _viewController.tokenSelectionActive)) {
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
//        NSLog(@"theEvent: %@", theEvent);
        [super keyDown:theEvent];
    }
}

@end
