
//  ActivityViewController.m
//  touch
//
//  Created by xinglunxu on 1/24/15.
//  Copyright (c) 2015 cs48. All rights reserved.


#import "ActivityViewController.h"
#import "ActivityListViewController.h"
#import "PFDefine.h"
@interface ActivityViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSArray *childViewControllers;
@property (strong, nonatomic) ActivityListViewController *activityList;
@property (strong, nonatomic) UIButton *editButton;


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.title = @"News Feed";
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, 50, 50);
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton setTitleColor:RGBACOLOR(169, 134, 75, 1) forState:UIControlStateNormal];
//    [self.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    
    self.activityList = [[ActivityListViewController alloc] init];
    
    
    [self addChildViewController:self.activityList];
    self.activityList.view.frame = self.view.frame;
    [self.view addSubview:self.activityList.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
