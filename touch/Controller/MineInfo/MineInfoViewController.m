//
//  MineInfoViewController.m
//  touch
//
//  Created by Ariel Xin on 2/19/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "MineInfoViewController.h"
#import "PersonalHomepageViewController.h"
#import "CommonDefine.h"
#import "User.h"
#import "SettingViewController.h"
#import "AppDelegate.h"

@interface MineInfoViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.myTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
}

//show navigation bar and custom tab bar
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[AppDelegate delegate] showTabBar];
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
//Define number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//Define number of rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    return 0;
}

//Define height of each section
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 112;
    }
    else if (indexPath.section == 1){
        return 43;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 11;
    }
    else if (section == 1){
        return 34;
    }
    return 0;
}

//Add context to each row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    //The first section in the table view is the entrance for User Profile page
    if (indexPath.section == 0) {
        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 80, 80)];
        headImageView.image = [UIImage imageNamed:@"mine_head.png"];
        headImageView.layer.borderWidth = 3.0;
        headImageView.layer.borderColor = [UIColor colorWithRed:0.906f green:0.906f blue:0.906f alpha:1.00f].CGColor;
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = 40;
        [cell.contentView addSubview:headImageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 47, 150, 17)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"Profile";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 21, 50, 8, 12)];
        arrowImageView.image = [UIImage imageNamed:@"mine_chevron.png"];
        
        [cell.contentView addSubview:arrowImageView];
        
        UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 111, SCREENWIDTH, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
        [cell.contentView addSubview:bottomLine];
    }
    //Second section is an entrance to setting page, which include a "logout" button
    else if (indexPath.section == 1){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 4, 35, 35)];
        imageView.image = [UIImage imageNamed:@"mine_set.png"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 200, 17)];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = @"Setting";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 21, 15, 8, 12)];
        arrowImageView.image = [UIImage imageNamed:@"mine_chevron.png"];
        [cell.contentView addSubview:arrowImageView];
        
        UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 42, SCREENWIDTH, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
        [cell.contentView addSubview:bottomLine];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        headView.frame = CGRectMake(0, 0, SCREENWIDTH, 11);
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(headView.frame) - 1, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
        [headView addSubview:line];
    }
    else if (section == 1){
        headView.frame = CGRectMake(0, 0, SCREENWIDTH, 34);
        UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(headView.frame) - 1, SCREENWIDTH, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1];
        [headView addSubview:bottomLine];
    }
    return headView;
}

//Navigation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        //go to personal homepage
        PersonalHomepageViewController *personVC = [[PersonalHomepageViewController alloc] init];
        personVC.userId = [[User currentUser] recordID];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate]hideTabBar];
        [self.navigationController pushViewController:personVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        //go to setting page
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate]hideTabBar];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
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
