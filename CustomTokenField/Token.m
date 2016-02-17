//
//  Token.m
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import "ViewController.h"
#import "Token.h"

@implementation Token {
    ViewController *__weak _viewController;
    NSTextField *_textField1;
    NSTextField *_textField2;
}

+ (Token*)createToken:(NSString*)text1 text2:(NSString*)text2 viewController:(ViewController*)viewController {
    NSTextField *textField1 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    textField1.stringValue = text1;
    textField1.font = [NSFont systemFontOfSize:12];
    textField1.frame = NSMakeRect(0, 0, textField1.attributedStringValue.size.width, 15);
    textField1.selectable = NO;
    textField1.editable = NO;
    textField1.bordered = NO;
    textField1.backgroundColor = [NSColor clearColor];

    NSTextField *textField2 = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    textField2.stringValue = text2;
    textField2.font = [NSFont systemFontOfSize:12];
    textField2.frame = NSMakeRect(0, 0, textField2.attributedStringValue.size.width, 15);
    textField2.selectable = NO;
    textField2.editable = NO;
    textField2.bordered = NO;
    textField2.backgroundColor = [NSColor clearColor];

    Token *token = [[Token alloc] initWithFrame:NSMakeRect(0, 0, 100, 100) viewController:viewController textField1:textField1 textField2:textField2];
    
    token.selected = NO;

    return token;
}

- (id)initWithFrame:(NSRect)frameRect viewController:(ViewController*)viewController textField1:(NSTextField*)textField1 textField2:(NSTextField*)textField2 {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        _viewController = viewController;
        _textField1 = textField1;
        _textField2 = textField2;
        
        [self addSubview:_textField1];
        [self addSubview:_textField2];
        
        _textField1.frame = NSMakeRect(0, 1, _textField1.frame.size.width, _textField1.frame.size.height);
        _textField2.frame = NSMakeRect(_textField1.frame.size.width + 1, 1, _textField2.frame.size.width, _textField2.frame.size.height);
        
        [self setFocusRingType:NSFocusRingTypeNone];
        
        self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, _textField1.frame.size.width + 1 + _textField2.frame.size.width, _textField1.frame.size.height + 1);
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSColor *fillColor;
    
    if(_selected) {
        _textField1.textColor = [NSColor whiteColor];
        _textField2.textColor = [NSColor whiteColor];
        
        fillColor = [NSColor colorWithCalibratedWhite:0.5 alpha:1.0];
    }
    else {
        _textField1.textColor = [NSColor blackColor];
        _textField2.textColor = [NSColor blackColor];

        fillColor = [NSColor colorWithCalibratedWhite:0.8 alpha:1.0];
    }
    
    CGFloat cornerRadius = 6;

    NSPoint topLeftCorner = NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds));
    NSPoint bottomLeftCorner = NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds));
    CGFloat midx = NSMinX(self.bounds) + _textField1.frame.size.width;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMinX(self.bounds), NSMinY(self.bounds) + cornerRadius)];
    [path curveToPoint:NSMakePoint(NSMinX(self.bounds) + cornerRadius, NSMinY(self.bounds)) controlPoint1:topLeftCorner controlPoint2:topLeftCorner];
    [path lineToPoint:NSMakePoint(midx, NSMinY(self.bounds))];
    [path lineToPoint:NSMakePoint(midx, NSMaxY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMinX(self.bounds) + cornerRadius, NSMaxY(self.bounds))];
    [path curveToPoint:NSMakePoint(NSMinX(self.bounds), NSMaxY(self.bounds) - cornerRadius) controlPoint1:bottomLeftCorner controlPoint2:bottomLeftCorner];

    [fillColor set];
    [path fill];

    NSPoint topRightCorner = NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds));
    NSPoint bottomRightCorner = NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds));
    
    path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(midx+1, NSMinY(self.bounds))];
    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds) - cornerRadius, NSMinY(self.bounds))];
    [path curveToPoint:NSMakePoint(NSMaxX(self.bounds), NSMinY(self.bounds) + cornerRadius) controlPoint1:topRightCorner controlPoint2:topRightCorner];
    [path lineToPoint:NSMakePoint(NSMaxX(self.bounds), NSMaxY(self.bounds) - cornerRadius)];
    [path curveToPoint:NSMakePoint(NSMaxX(self.bounds) - cornerRadius, NSMaxY(self.bounds)) controlPoint1:bottomRightCorner controlPoint2:bottomRightCorner];
    [path lineToPoint:NSMakePoint(midx+1, NSMaxY(self.bounds))];
    
    [fillColor set];
    [path fill];
}


- (void)setSelected:(BOOL)selected {
    _selected = selected;

    self.needsDisplay = YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    [_viewController tokenMouseDown:self event:theEvent];
}

@end
