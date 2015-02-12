//
//  UserListViewController.m
//  touch
//
//  Created by CharlesYJP on 2/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "UserListViewController.h"
//#import "UserCell.h"
//#import "JCUser.h"
#import "PersonalHomepageViewController.h"
@interface UserListViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    switch (self.listType) {
        case UserListTypeFriend:
        {
            self.title = @"好友列表";
        }
            break;
        case UserListTypeFollowee:
        {
            self.title = @"关注列表";
        }
            break;
        case UserListTypeFollower:
        {
            self.title = @"粉丝列表";
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate & UItableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"UserCell";
    UserCell *cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    JCUser *user = (JCUser *)[JCUser userWithUserId:self.userDataSource[indexPath.row]];
    __weak __typeof(JCUser) *wUser = user;
    wUser.recordID = user.recordID;
    [wUser getNameAndUserAvatar:^(BOOL succeeded, NSError *error) {
        [cell.headButton setBackgroundImage:wUser.squareImage forState:UIControlStateNormal];
        cell.userNameLabel.text = wUser.name;
    }];
    cell.block = ^{
        PersonalHomepageViewController *personHome = [[PersonalHomepageViewController alloc] init];
        personHome.userId = wUser.recordID;
        [self.navigationController pushViewController:personHome animated:YES];
    };
    return cell;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonalHomepageViewController *personHome = [[PersonalHomepageViewController alloc] init];
//    personHome.userId = self.userDataSource[indexPath.row];
    [self.navigationController pushViewController:personHome animated:YES];
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

