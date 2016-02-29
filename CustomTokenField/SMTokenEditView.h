//
//  SMEditToken.h
//  CustomTokenField
//
//  Created by Evgeny Baskakov on 2/12/16.
//  Copyright © 2016 Evgeny Baskakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMTokenView;
@class SMTokenFieldViewController;

@interface SMTokenEditView : NSTextView

@property SMTokenView __weak *parentToken;

+ (SMTokenEditView*)createEditToken:(SMTokenFieldViewController*)viewController;

@end
