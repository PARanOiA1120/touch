//
//  CustomTabBar.m
//  touch
//
//  Created by xinglunxu on 1/19/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "CustomTabBar.h"
//#import "CustomAnimationView.h"
typedef NS_ENUM(NSInteger, TabBarButtonTag)
{
    TabBarButtonTag_Activity = 0,
    TabBarButtonTag_Square,
    TabBarButtonTag_Message,
    TabBarButtonTag_UserInfo
};

#define CustomTabBar_buttonNormalImages   @[@"tab_activity.png",@"tab_square.png",@"tab_message.png",@"tab_user.png"]
#define CustomTabBar_buttonSelectedImages   @[@"tab_activity_p.png",@"tab_square_p.png",@"tab_message_p.png",@"tab_user_p.png"]
@interface CustomTabBar ()<UINavigationControllerDelegate>
@property (strong, nonatomic) UIButton *activityBtn;
@property (strong, nonatomic) UIButton *squareBtn;
@property (strong, nonatomic) UIButton *messageBtn;
@property (strong, nonatomic) UIButton *userInfoBtn;
@property (strong, nonatomic) NSMutableArray *selectedImage;


@end


@implementation CustomTabBar

-(void)viewDidLoad{
    [super viewDidLoad];
    self.slideBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.tabBar.frame.size.height, self.view.frame.size.width, self.tabBar.frame.size.height)];
    self.slideBg.backgroundColor = [UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f];
    self.slideBg.userInteractionEnabled = YES;
    [self.view addSubview:self.slideBg];
//    [self hideRealTabBar];
    [self customTabBar];
}

- (void)showCustomTabBar
{
    self.slideBg.hidden = NO;
}

- (void)customTabBar{
    //创建按钮
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

}

- (void)selectedTab:(UIButton *)button
{
    [self setSelectedTag:button.tag];
}

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



@end
