//
//  SMEditToken.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMViewController;

@interface SMEditToken : NSTextView

+ (SMEditToken*)createEditToken:(SMViewController*)viewController;

@end
