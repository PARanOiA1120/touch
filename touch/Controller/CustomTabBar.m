//
//  CustomTabBar.m
//  touch
//
//  Created by xinglunxu on 1/19/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "CustomTabBar.h"
#import "VBFPopFlatButton.h"
#import "DRNRealTimeBlurView.h"
#import "CustomAnimationView.h"
#import "NewStatusViewController.h"
#import "CampaignViewController.h"
#import "CustomItem.h"
#import "PersonalHomepageViewController.h" //Mark for deletion

typedef NS_ENUM(NSInteger, TabBarButtonTag)
{
    TabBarButtonTag_Activity = 0,
    TabBarButtonTag_Square,
    TabBarButtonTag_Message,
    TabBarButtonTag_UserInfo
};

#define CustomTabBar_buttonNormalImages   @[@"tab_activity.png",@"tab_square.png",@"tab_message.png",@"tab_user.png"]
#define CustomTabBar_buttonSelectedImages   @[@"tab_activity_p.png",@"tab_square_p.png",@"tab_message_p.png",@"tab_user_p.png"]
#define SCREENWIDTH         CGRectGetWidth([UIScreen mainScreen].bounds)

@interface CustomTabBar ()<UINavigationControllerDelegate, CustomAnimationViewDelegate>
@property (strong, nonatomic) UIButton *activityBtn;
@property (strong, nonatomic) UIButton *squareBtn;
@property (strong, nonatomic) UIButton *messageBtn;
@property (strong, nonatomic) UIButton *userInfoBtn;
@property (strong, nonatomic) NSMutableArray *selectedImage;
@property (strong, nonatomic) VBFPopFlatButton *centerAddBtn;
@property (strong, nonatomic) DRNRealTimeBlurView *blurView;
@property (strong, nonatomic) CustomAnimationView *customAnimationView;
@property (strong, nonatomic) UIView *backView;



@end


@implementation CustomTabBar

-(void)viewDidLoad{
    [super viewDidLoad];
    self.slideBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.tabBar.frame.size.height, self.view.frame.size.width, self.tabBar.frame.size.height)];
    self.slideBg.backgroundColor = [UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f];
    self.slideBg.userInteractionEnabled = YES;
    [self.view addSubview:self.slideBg];
    [self customTabBar];
}

- (void)showCustomTabBar
{
    self.slideBg.hidden = NO;
}

- (void)customTabBar{
    int viewCount = 4;
    
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    CGFloat buttonWidth = (self.tabBar.frame.size.width - 57) / viewCount;
    
    CGFloat buttonHeight = self.tabBar.frame.size.height;
    
    self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activityBtn.frame = CGRectMake(0,0, buttonWidth, buttonHeight);
    [self.activityBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    self.activityBtn.tag = TabBarButtonTag_Activity;
    [self.slideBg addSubview:self.activityBtn];
    [self.buttons addObject:self.activityBtn];
    
    self.squareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.squareBtn.frame = CGRectMake(buttonWidth,0, buttonWidth, buttonHeight);
    [self.squareBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    self.squareBtn.tag = TabBarButtonTag_Square;
    [self.slideBg addSubview:self.squareBtn];
    [self.buttons addObject:self.squareBtn];
    
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageBtn.frame = CGRectMake(buttonWidth*2 +57,0, buttonWidth, buttonHeight);
    [self.messageBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.tag = TabBarButtonTag_Message;
    [self.slideBg addSubview:self.messageBtn];
    [self.buttons addObject:self.messageBtn];
    
    self.userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userInfoBtn.frame = CGRectMake(buttonWidth*3 + 57,0, buttonWidth, buttonHeight);
    [self.userInfoBtn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
    self.userInfoBtn.tag = TabBarButtonTag_UserInfo;
    [self.slideBg addSubview:self.userInfoBtn];
    [self.buttons addObject:self.userInfoBtn];
    
    //center activity icon
    self.centerAddBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake((SCREENWIDTH - 57)/2, 4, 57, 40) buttonType:buttonAddType buttonStyle:buttonPlainStyle animateToInitialState:NO];
    [self.centerAddBtn  setBackgroundColor:[UIColor colorWithRed:184/255.0f green:150/255.0f blue:101/255.0f alpha:1.0]];
    [self.centerAddBtn addTarget:self action:@selector(centerAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.slideBg addSubview:self.centerAddBtn];


}

- (void)selectedTab:(UIButton *)button
{
    [self setSelectedTag:button.tag];
}

//set up all the buttons with their icons, and
//find the one that's being selected and replace its icon with a selected-version one
- (void)setSelectedTag:(NSInteger)tag{
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        [btn setImage:[UIImage imageNamed:CustomTabBar_buttonNormalImages[i]] forState:UIControlStateNormal];
    }
    self.currentSelectedIndex = tag;
    [self.buttons[tag] setImage:[UIImage imageNamed:CustomTabBar_buttonSelectedImages[self.currentSelectedIndex]] forState:UIControlStateNormal];
    if (self.selectedIndex != tag) {
        [self setSelectedIndex:tag];
    }
}

- (void)centerAddBtnClicked:(UIButton *)button
{
    NSLog(@"centerAddBtn clicked");
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        button.backgroundColor = [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0];
    } completion:^(BOOL finished)
     {
         button.transform = CGAffineTransformMakeScale(1, 1);
         button.backgroundColor = [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0];
         [self.centerAddBtn animateToType:buttonCloseType];
         
         CGRect rect = [UIScreen mainScreen].bounds;
         if (!self.blurView) {
             self.blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) tintColor:[UIColor blackColor]];
         }
         self.blurView.alpha = 0;
         [self.view addSubview:self.blurView];
         [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
             self.blurView.alpha = 1;
         } completion:^(BOOL finished) {
             self.slideBg.hidden = YES;
             if (!self.customAnimationView) {
                 self.customAnimationView = [[CustomAnimationView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                 self.customAnimationView.delegate = self;
             }
             [self.view addSubview:self.customAnimationView];
             [self.customAnimationView beginAnimations];
             
         }];
         
     }];
}

- (void)dismissCustomAnimationView
{
    [self resetTabBar];
    [UIView animateWithDuration:0.7 animations:^{
        self.blurView.alpha = 0.0f;
        self.customAnimationView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.customAnimationView removeFromSuperview];
        self.customAnimationView = nil;
        [self.blurView removeFromSuperview];
    }];
}

- (void)resetTabBar
{
    self.centerAddBtn.currentButtonType = buttonAddType;
    self.centerAddBtn.backgroundColor = [UIColor colorWithRed:184/255.0f green:150/255.0f blue:101/255.0f alpha:1.0];
    [self showCustomTabBar];
}


- (void)itemClicked:(CustomItem *)item
{
    [self resetTabBar];
    [UIView animateWithDuration:0.7 animations:^{
        self.blurView.alpha = 0.0f;
        _backView.alpha = 0.0;
        self.customAnimationView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.customAnimationView removeFromSuperview];
        self.customAnimationView = nil;
        [self.blurView removeFromSuperview];
        [_backView removeFromSuperview];
    }];
    
    if (item.function == Function_type_state) {
        NewStatusViewController *newStatusVC = [[NewStatusViewController alloc] init];
        newStatusVC.delegate = self.viewControllers[0];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newStatusVC];
        [self presentViewController:navController animated:YES completion:^{}];
        return;
    }else if (item.function == Function_type_activity) {
        CampaignViewController *campaignController = [[CampaignViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:campaignController];
        [self presentViewController:navController animated:YES completion:^{}];
    }
    //Mark for deletion
    else {
        PersonalHomepageViewController *campaignController = [[PersonalHomepageViewController alloc] init];
        //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:campaignController];
        [self presentViewController:campaignController animated:YES completion:^{}];
    }
    //Mark for deletion
}


@end
