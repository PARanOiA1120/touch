//
//  PersonalHomepageViewController.h
//  touch
//
//  Created by CharlesYJP on 2/7/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat kPersonalHomeViewSeprator = 0.618;

typedef NS_ENUM(NSInteger, TableViewDataSourceType)
{
    TableViewDataSourceType_Info = 0,
    TableViewDataSourceType_News,
    TableViewDataSourceType_Activity,
    TableViewDataSourceType_Map
};

typedef NS_ENUM(NSInteger, UserType)
{
    UserTypeSelf = 0, //current user
    UserTypeOther = 1 //not current user
};
@interface PersonalHomepageViewController : UIViewController
@property (strong, nonatomic) NSString *userId;
@property (nonatomic) UserType userType;
@end

