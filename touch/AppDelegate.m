//
//  AppDelegate.m
//  touch
//
//  Created by Ariel Xin on 1/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate () <ICETutorialControllerDelegate>
@property (strong, nonatomic) ICETutorialController *introController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"8428ZqzEOt8YKpxnyfUtNJIF7wjWoGmGSBzDTGyV"
                  clientKey:@"zOgywuFz7u9YAXWgpkPJsPlhKbBvGDYwyg5YuKSe"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
 
    
    self.window.backgroundColor = [UIColor whiteColor];
    NSLog(@" window frame  %@",NSStringFromCGRect([[UIScreen mainScreen]bounds]));
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f]];
    
    [self goToIntro];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (AppDelegate *)delegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)goToIntro
{
    IntroViewController *introView = [[IntroViewController alloc] init];
    //NSLog(@"5");
    self.window.rootViewController = introView;
    [self.window makeKeyAndVisible];
}

@end


