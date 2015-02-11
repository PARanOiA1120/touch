//
//  NewInfoViewController.m
//  touch
//
//  Created by zhu on 2/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "NewInfoViewController.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
@interface NewInfoViewController ()
<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) CGFloat translationY;
@end

@implementation NewInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.dataSource = [@[
                         @{
                             @"newInfo_type":@"0",//0代表普通的状态
                             @"newInfo_title":@"bunji like my post",
                             @"newInfo_content":@"It is so cold out there. I should wear some more clothes，take care my friends",
                             @"head":@"newinfo_head.png",
                             @"userName":@"bob"
                             },
                         
                         @{
                             @"newInfo_type":@"1",//1代表通知 谁关注了我，谁和我有30个共同好友
                             @"newInfo_title":@"bunji follows me",
                             @"head":@"newinfo_head.png",
                             @"userName":@"bob"
                             },
                         @{
                             @"newInfo_type":@"2",//2代表通知 谁关注了谁
                             @"newInfo_title":@"benji follows bob",
                             @"head":@"newinfo_head.png",
                             @"otherHead":@"newinfo_head.png",
                             @"userName":@"bob"
                             },
                         
                         @{
                             @"newInfo_type":@"3",//3代表 谁点赞了我参加的活动
                             @"newInfo_title":@"bunji likes my activity",
                             @"head":@"newinfo_head.png",
                             @"userName":@"bob",
                             @"activityInfo":@{
                                     @"activityPic":@[@"activity_pic.png"],
                                     @"activityContent":@"[Christmas]Chrismas night party, everyone welcomed，DO NOT passby"
                                     
                                     }
                             },
                         
                         @{
                             @"newInfo_type":@"4",//4代表 谁点赞了我的照片
                             @"newInfo_title":@"benji likes my photos",
                             @"head":@"newinfo_head.png",
                             @"userName":@"bob",
                             @"activityInfo":@{
                                     @"activityPic":@[@"activity_pic.png",@"activity_pic.png",@"activity_pic.png",@"activity_pic.png"],
                                     }
                             
                         
                             }
                         
                         ]mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)calculateCellHeight:(NSDictionary *)dic
{
    CGFloat height = 0.0f;
    
    if ([dic[@"newInfo_type"] isEqualToString:@"0"]) {
        //0代表普通的状态
        height  = height + 30;//title 高度
        
        NSString *content = dic[@"newInfo_content"];
        height = height + [self calculateViewHeight:content withViewWidth:SCREEN_WIDTH - 70 withFont:[UIFont fontWithName:DEFAULT_FONT_LIGHT size:13]] + 10;
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"1"])
    {
        //1代表通知 谁关注了我，谁和我有30个共同好友
        height = height + 45;
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"2"])
    {
        //2代表通知 谁关注了谁
        height = height + 45;
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"3"])
    {
        //3代表 谁点赞了我参加的活动
        height  = height + 30;//title 高度
        
        height = height + 75 + 10;//活动图和描述的高度 以及下边缘 间隙
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"4"])
    {
        //4代表 谁点赞了我的照片
        height  = height + 30;//title 高度
        
        height = height + 45 + 10;//图片高度 以及下边缘 间隙
    }
    return height;
}



- (CGFloat)calculateViewHeight:(NSString *)text withViewWidth:(CGFloat)width withFont:(UIFont *)font
{
    CGSize size;
    size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.height;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateCellHeight:self.dataSource[indexPath.row]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    
    UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 40, 40)];
    headImageView.image = [UIImage imageNamed:dic[@"head"]];
    [cell.contentView addSubview:headImageView];
    
    if ([dic[@"newInfo_type"] isEqualToString:@"0"]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREENWIDTH - 1 - 60, 20)];
        titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:15];
        titleLabel.text = dic[@"newInfo_title"];
        [cell.contentView addSubview:titleLabel];
        
        NSString *content = dic[@"newInfo_content"];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, SCREENWIDTH - 70, [self calculateViewHeight:content withViewWidth:SCREEN_WIDTH - 70 withFont:[UIFont fontWithName:DEFAULT_FONT_LIGHT size:13]])];
        contentLabel.text = content;
        contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:13];
        contentLabel.numberOfLines = 0;
        [cell.contentView addSubview:contentLabel];
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"1"])
    {
        //1代表通知 谁关注了我，谁和我有30个共同好友
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREENWIDTH - 70, 45)];
        contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:15];
        contentLabel.text = dic[@"newInfo_title"];
        [cell.contentView addSubview:contentLabel];
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"2"])
    {
        //2代表通知 谁关注了谁
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREENWIDTH - 70, 45)];
        contentLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:15];
        contentLabel.text = dic[@"newInfo_title"];
        [cell.contentView addSubview:contentLabel];
        
        UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 50, 3, 40, 40)];
        headImageView.image = [UIImage imageNamed:dic[@"otherHead"]];
        [cell.contentView addSubview:headImageView];
        
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"3"])
    {
        //3代表 谁点赞了我参加的活动
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREENWIDTH - 1 - 60, 20)];
        titleLabel.text = dic[@"newInfo_title"];
        titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:15];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 30, 75, 75)];
        imageView.image = [UIImage imageNamed:dic[@"activityInfo"][@"activityPic"][0]];
        [cell.contentView addSubview:imageView];
        
        UILabel *activityContent = [[UILabel alloc] initWithFrame:CGRectMake(135, 30, SCREENWIDTH - 135 - 10, 75)];
        activityContent.numberOfLines = 0;
        activityContent.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0f];
        activityContent.layer.borderColor = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1.0f].CGColor;
        activityContent.layer.borderWidth = 0.5;
        activityContent.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:14];
        activityContent.text = dic[@"activityInfo"][@"activityContent"];
        [cell.contentView addSubview:activityContent];
    }
    else if ([dic[@"newInfo_type"] isEqualToString:@"4"])
    {
        //4代表 谁点赞了我的照片
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREENWIDTH - 1 - 60, 20)];
        titleLabel.text = dic[@"newInfo_title"];
        titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:15];
        [cell.contentView addSubview:titleLabel];
        
        NSArray *imageArray = dic[@"activityInfo"][@"activityPic"];
        NSInteger maxCount = imageArray.count > 4 ? 4 : imageArray.count;
        for (int i = 0; i < maxCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60 + i*50, 30, 45, 45)];
            imageView.image = [UIImage imageNamed:imageArray[i]];
            [cell.contentView addSubview:imageView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y < self.translationY) {
        self.parentViewController.navigationController.navigationBarHidden = YES;
//        [[AppDelegate delegate] hideTabBar];
        self.parentViewController.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    }
    else
    {
        self.parentViewController.navigationController.navigationBarHidden = NO;
        [[AppDelegate delegate] showTabBar];
        self.parentViewController.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 44 - 49);
    }
    self.translationY = translation.y;
    NSLog(@"%f",translation.y);
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
