//
//  UserListViewController.h
//  touch
//
//  Created by CharlesYJP on 2/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, UserListType){
    UserListTypeFriend = 0, //好友列表
    UserListTypeFollowee = 1, //关注列表
    UserListTypeFollower = 2 //粉丝列表
};

@interface UserListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *userDataSource;
@property (nonatomic) UserListType listType;
@end
