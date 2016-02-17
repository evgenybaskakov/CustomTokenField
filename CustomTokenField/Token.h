//
//  Token.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ViewController;

@interface Token : NSView

@property (readonly) NSString *tokenName;
@property (readonly) NSString *contentsText;
@property (readonly) id target;
@property (readonly) SEL selector;

@property (nonatomic) BOOL selected;

+ (Token*)createToken:(NSString*)tokenName contentsText:(NSString*)contentsText target:(id)target selector:(SEL)selector viewController:(ViewController*)viewController;

@end
