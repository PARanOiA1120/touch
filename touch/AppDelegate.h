//
//  AppDelegate.h
//  touch
//
//  Created by Ariel Xin on 1/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBar *tabBarController;

+ (AppDelegate *)delegate;

//go to the introduction/guding pages
- (void)goToIntro;
//go to loginViewController when the login button is tapped
- (void)goToLogin;
//go to the main page after user logged in
- (void)createTabBar;
//navigates user among news fees, notification center, chatting and personal homepage
- (void)selectTab:(NSInteger)tab;
//show tab bar
- (void)showTabBar;
//hide tab bar
- (void)hideTabBar;



@end

