//
//  CommonDefine.h
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

//This file is used to define some frequently used parameters

#ifndef touch_CommonDefine_h
#define touch_CommonDefine_h

#import <Parse/Parse.h>

#define IOS7_UP                ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ? YES : NO )
#define IOS8_UP                ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0 ? YES : NO )

#define IOS7                (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) ? YES : NO )
#define IOS8                (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] doubleValue] < 9.0) ? YES : NO )

#define IPHONE5             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREENWIDTH         CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT        CGRectGetHeight([UIScreen mainScreen].bounds)

#define DEFAULT_FONT        @"STHeitiSC-Medium"
#define DEFAULT_FONT_LIGHT  @"STHeitiSC-Light"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_TRUE_6P ([UIScreen mainScreen].scale > 2.9 ? YES : NO)
#define IS_TRUE_6 ([UIScreen mainScreen].scale < 2.1 ? YES : NO)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0 && IS_TRUE_6)
#define IS_IPHONE_6P (IS_IPHONE && IS_TRUE_6P)

#define SAFEPARAMETER(parameter)    (parameter) ? [NSString stringWithFormat:@"%@",parameter] : @""



#pragma mark Notification define
#define UIActivityCircleNeedRefreshDataNotification @"UIActivityCircleNeedRefreshDataNotification"


#endif
