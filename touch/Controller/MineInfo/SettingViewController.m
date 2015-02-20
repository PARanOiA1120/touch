//
//  SettingViewController.m
//  touch
//
//  Created by Ariel Xin on 2/19/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "SettingViewController.h"
#import "User.h"
#import "IntroViewController.h"

#define Setting_TitileArray @[@[@"Account Security"],@[@"New Announcement",@"Privacy",@"General"],@[@"About Touch"],@[@"Logout"]]

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Setting_TitileArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2 || section == 3) {
        return 1;
    }
    else if (section == 1){
        return 3;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else if (section == 3)
    {
        return 97;
    }
    else
    {
        return 28;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = Setting_TitileArray[indexPath.section][indexPath.row];
    return cell;
}


//If user clicks the logout button, back to the Intro View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3){
        [[User currentUser] logOut];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"IconCache"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ICON_CACHED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        IntroViewController *introView = [[IntroViewController alloc] init];
        [self presentViewController:introView animated:YES completion:^{
            NSLog(@"logged out");
        }];
        
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
