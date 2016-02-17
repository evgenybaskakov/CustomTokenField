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

@property (nonatomic) BOOL selected;

+ (Token*)createToken:(NSString*)text1 text2:(NSString*)text2 viewController:(ViewController*)viewController;

@end
