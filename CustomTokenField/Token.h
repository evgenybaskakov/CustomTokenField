//
//  Token.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/11/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ViewController;

@interface Token : NSTextField

+ (Token*)createToken:(NSString*)text viewController:(ViewController*)viewController rect:(NSRect)rect;

@end
