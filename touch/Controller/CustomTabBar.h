//
//  CustomTabBar.h
//  touch
//
//  Created by xinglunxu on 1/19/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CustomTabBar : UITabBarController

@property (nonatomic,assign) NSInteger currentSelectedIndex;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIImageView *slideBg;

- (void)customTabBar;
- (void)setSelectedTag:(NSInteger)tag;
- (void)showCustomTabBar;
- (void)resetTabBar;
- (void)hideCustomTabBar;

@end
