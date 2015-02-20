//
//  PersonalHomepageViewController.m
//  touch
//
//  Created by CharlesYJP on 2/7/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//  This class is based on PersonalHomepageViewController.m by Jack Zeng


#import "PersonalHomepageViewController.h"
#import "DRNRealTimeBlurView.h"
#import "User.h"
#import "PersonalInfoViewController.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
#define Personal_Info @[@"Name",@"Gender", @"Major",@"Class Level",@"Skills"]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface PersonalHomepageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) UIView *actionView;
@property (strong, nonatomic) UIImageView *largeImageView;

@property (strong, nonatomic) UIView *tableHeaderView;
@property (strong, nonatomic) UIView *userInfoView;
@property (strong, nonatomic) UIView *userHeadView;
@property (strong, nonatomic) UIImageView *userHeadImageView;
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIImageView *sexImageView;

@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *newsButton;
@property (strong, nonatomic) UIButton *activityButton;
@property (strong, nonatomic) UIButton *mapButton;

//the selected one of the four buttons
@property (nonatomic) NSInteger selectedIndex;
//store personal information, when selecting information
@property (strong, nonatomic) NSMutableArray *userInfoArray;
//store array of news feed, when selectingfeed
@property (strong, nonatomic) NSArray *newsArray;
//store array of activity, when selecting activity
@property (strong, nonatomic) NSArray *activityArray;
//store array of map, when selecting map
@property (strong, nonatomic) NSArray *mapArray;
@property (strong, nonatomic) User *user;

- (IBAction)navigationBtnClicked:(id)sender;

@end

@implementation PersonalHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (IOS7_UP) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    [self layoutTableHeaderView];
    [self.view addSubview:self.tableHeaderView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(260, 25, 50*5, 31)];
    self.actionView.backgroundColor = RGBACOLOR(191, 191, 170, 0.65);
    self.actionView.layer.masksToBounds = YES;
    self.actionView.layer.cornerRadius = 15;
    self.actionView.alpha = 0;
    [self.view addSubview:self.actionView];
    
    self.backButton.layer.masksToBounds = YES;
    self.backButton.layer.cornerRadius = self.backButton.frame.size.height/2;
    
    self.user = [User userWithUserId:self.userId];
    
    if([self.user.recordID isEqualToString:[User currentUser].recordID]){
        self.userType = UserTypeSelf;
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editButton.titleLabel setTextColor:[UIColor whiteColor]];
    }
    else{
        self.userType = UserTypeOther;
        [self.editButton setImage:[UIImage imageNamed:@"personal_icon_edit"] forState:UIControlStateNormal];
        [self.editButton setTitle:@"" forState:UIControlStateNormal];
    }
    self.editButton.layer.masksToBounds = YES;
    self.editButton.layer.cornerRadius = self.backButton.frame.size.height/2;
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.editButton];
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT * kPersonalHomeViewSeprator)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.scrollEnabled = NO;
    [self.view addSubview:self.myTableView];
    
    [self setExtraCellLineHidden:self.myTableView];
}

- (void)layoutTableHeaderView{
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableHeaderView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responseToGesture:)];
    swipGesture.direction = UISwipeGestureRecognizerDirectionDown;
    swipGesture.numberOfTouchesRequired = 1;
    [self.tableHeaderView addGestureRecognizer:swipGesture];
    
    self.largeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.largeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableHeaderView addSubview:self.largeImageView];
    
    DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT *kPersonalHomeViewSeprator, SCREENWIDTH, SCREENHEIGHT *(1 - kPersonalHomeViewSeprator)) tintColor:[UIColor colorWithRed:108/255.0f green:122/255.0f blue:137/255.0f alpha:0.4f]];
    [self.tableHeaderView addSubview:blurView];
    
    CGFloat superViewHeight = CGRectGetHeight(blurView.frame);
    
    self.userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, superViewHeight * kPersonalHomeViewSeprator)];
    self.userInfoView.backgroundColor = [UIColor clearColor];
    [blurView addSubview:self.userInfoView];
    //name Label
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH *2/3, superViewHeight*kPersonalHomeViewSeprator*2/3)];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    self.userNameLabel.font = [UIFont fontWithName:DEFAULT_FONT_LIGHT size:30];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.userInfoView addSubview:self.userNameLabel];
    
    //gender label
    self.sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 35, (CGRectGetHeight(self.userNameLabel.frame) - 14)/2, 14, 14)];
    //self.sexImageView.image = [UIImage imageNamed:@"personal_icon_female.png"];
    [self.userInfoView addSubview:self.sexImageView];
    
    //mid transverse line
    UIImageView *horizonalLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameLabel.frame) - 0.5, SCREENWIDTH, 0.5)];
    horizonalLine.backgroundColor = RGBACOLOR(215, 215, 215, 1);
    [self.userInfoView addSubview:horizonalLine];
    
    int buttonWidth = floorf(SCREENWIDTH/3);
    
    //small head image
    self.userHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, superViewHeight * kPersonalHomeViewSeprator)];
    self.userHeadView.backgroundColor = [UIColor clearColor];
    [blurView addSubview:self.userHeadView];
    
    CGFloat length = 0.0;
    if (IS_IPHONE_6P){
        length = 90;
    }
    if (IS_IPHONE_6){
        length = 80;
    }
    if (IS_IPHONE_5){
        length = 75;
    }
    if (IS_IPHONE_4_OR_LESS){
        length = 65;
    }
    NSLog(@"%f",[UIScreen mainScreen].scale);
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    self.userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.userHeadView.frame) - length)/2, (CGRectGetHeight(self.userHeadView.frame) - length) / 2 + 10, length, length)];
    self.userHeadImageView.layer.borderWidth = 3.0f;
    self.userHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userHeadImageView.layer.masksToBounds = YES;
    self.userHeadImageView.layer.cornerRadius = self.userHeadImageView.frame.size.width / 2;
    NSLog(@"%f",self.userHeadImageView.frame.size.height);
    [self.userHeadView addSubview:self.userHeadImageView];
    self.userHeadView.hidden = YES;
    
    CGFloat btnWidth = SCREENWIDTH/4;
    
    //information Button
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.frame = CGRectMake(btnWidth * 0, CGRectGetHeight(blurView.frame)*kPersonalHomeViewSeprator, btnWidth, CGRectGetHeight(blurView.frame)*(1 - kPersonalHomeViewSeprator));
    [self.infoButton.titleLabel setTextColor:[UIColor whiteColor]];
    self.infoButton.tag = TableViewDataSourceType_Info;
    self.infoButton.backgroundColor = [UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f];
    [self.infoButton setImage:[UIImage imageNamed:@"personal_icon_head_normal.png"] forState:UIControlStateNormal];
    [self.infoButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:self.infoButton];
    
    //news button
    self.newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.newsButton.frame = CGRectMake(btnWidth * 1, CGRectGetHeight(blurView.frame)*kPersonalHomeViewSeprator, btnWidth, CGRectGetHeight(blurView.frame)*(1 - kPersonalHomeViewSeprator));
    [self.newsButton.titleLabel setTextColor:[UIColor whiteColor]];
    self.newsButton.tag = TableViewDataSourceType_News;
    self.newsButton.backgroundColor = [UIColor colorWithRed:229/255.0f green:216/255.0f blue:189/255.0f alpha:1.0f];
    [self.newsButton setImage:[UIImage imageNamed:@"personal_icon_new_normal.png"] forState:UIControlStateNormal];
    [self.newsButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:self.newsButton];
    
    //activity
    self.activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.activityButton.frame = CGRectMake(btnWidth * 2, CGRectGetHeight(blurView.frame)*kPersonalHomeViewSeprator, btnWidth, CGRectGetHeight(blurView.frame)*(1 - kPersonalHomeViewSeprator));
    [self.activityButton.titleLabel setTextColor:[UIColor whiteColor]];
    self.activityButton.tag = TableViewDataSourceType_Activity;
    self.activityButton.backgroundColor = [UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f];
    [self.activityButton setImage:[UIImage imageNamed:@"personal_icon_activity_normal.png"] forState:UIControlStateNormal];
    [self.activityButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:self.activityButton];
    
    //map
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mapButton.frame = CGRectMake(btnWidth * 3, CGRectGetHeight(blurView.frame)*kPersonalHomeViewSeprator, btnWidth, CGRectGetHeight(blurView.frame)*(1 - kPersonalHomeViewSeprator));
    [self.mapButton.titleLabel setTextColor:[UIColor whiteColor]];
    self.mapButton.tag = TableViewDataSourceType_Map;
    self.mapButton.backgroundColor = [UIColor colorWithRed:229/255.0f green:216/255.0f blue:189/255.0f alpha:1.0f];
    [self.mapButton setImage:[UIImage imageNamed:@"personal_icon_map_normal.png"] forState:UIControlStateNormal];
    [self.mapButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:self.mapButton];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[AppDelegate delegate] showTabBar];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //add nofification observer
    
    [[AppDelegate delegate] hideTabBar];
    self.navigationController.navigationBarHidden = YES;
    
    if ([self.user.recordID isEqualToString:[User currentUser].recordID]) {
        self.userType = UserTypeSelf;
    }
    else{
        self.userType = UserTypeOther;
    }
    
    //doing this when it's not the current user
    //fake data
    self.newsArray = @[@{@"time":@"Feb 11",
                         @"news":@[@{@"image":@"personal_activity_head.png",@"content":@"ViewController",@"title":@"CS48Project",@"location":@"CSIL"}]},
                       @{@"time":@"Feb 11",
                         @"news":@[@{@"image":@"personal_activity_head.png",@"content":@"TableViewController",@"title":@"CS48Project",@"location":@"CSIL"},@{@"image":@"personal_activity_head.png",@"content":@"TableCell",@"title":@"CS48Project",@"location":@"CSIL"}]}];
    
    self.activityArray = @[@{@"time":@"Feb 12",
                             @"activity":@[@{@"image":@"personal_activity_head.png",@"content":@"PersonalHomepageViewController in progress"}]},
                           @{@"time":@"Feb 11",
                             @"activity":@[@{@"image":@"personal_activity_head.png",@"content":@"UserListViewController in progress"},@{@"image":@"personal_activity_head.png",@"content":@"PersonInfoCell in progress"}]}];
    
    self.mapArray = @[];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"I got called");
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//setcolor for 4 buttons, and the line in tableview
- (void)configButtonBackgroundColor:(NSInteger)index
{
    [self.infoButton setBackgroundColor:index == 0 ? [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0f] : [UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f]];
    [self.infoButton setImage:[UIImage imageNamed:index == 0 ? @"personal_icon_head_selected.png":@"personal_icon_head_normal.png"] forState:UIControlStateNormal];
    
    [self.newsButton setBackgroundColor:index == 1 ? [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0f] : [UIColor colorWithRed:229/255.0f green:216/255.0f blue:189/255.0f alpha:1.0f]];
    [self.newsButton setImage:[UIImage imageNamed:index == 1 ? @"personal_icon_new_selected.png":@"personal_icon_new_normal.png"] forState:UIControlStateNormal];
    
    [self.activityButton setBackgroundColor:index == 2 ? [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0f] : [UIColor colorWithRed:247/255.0f green:240/255.0f blue:225/255.0f alpha:1.0f]];
    [self.activityButton setImage:[UIImage imageNamed:index == 2 ? @"personal_icon_activity_selected.png":@"personal_icon_activity_normal.png"] forState:UIControlStateNormal];
    
    [self.mapButton setBackgroundColor:index == 3 ? [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0f] : [UIColor colorWithRed:229/255.0f green:216/255.0f blue:189/255.0f alpha:1.0f]];
    [self.mapButton setImage:[UIImage imageNamed:index == 3 ? @"personal_icon_map_selected.png":@"personal_icon_map_normal.png"] forState:UIControlStateNormal];
    
    if (index == 0) {
        [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    else
    {
        [self.myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonClicked:(id)sender {
    
    self.myTableView.tag = ((UIButton *)sender).tag;
    self.selectedIndex = ((UIButton *)sender).tag;
    [self configButtonBackgroundColor:((UIButton *)sender).tag];
    [self.myTableView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableHeaderView.frame = CGRectMake(0, -(SCREENHEIGHT * kPersonalHomeViewSeprator), self.tableHeaderView.frame.size.width, self.tableHeaderView.frame.size.height);
        self.myTableView.frame = CGRectMake(0, SCREENHEIGHT *(1 - kPersonalHomeViewSeprator), self.myTableView.frame.size.width, self.myTableView.frame.size.height);
        self.backButton.alpha = 1.0;
        self.editButton.alpha = 0;
        self.userInfoView.hidden = YES;
        self.userHeadView.hidden = NO;
        if (((UIButton *)sender).tag == 3) {
            self.myTableView.hidden = YES;
        }
        else{
            self.myTableView.hidden = NO;
        }
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.backButton];
        self.myTableView.scrollEnabled = YES;
    }];
}

//tableHeaderView
- (void)responseToGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tableHeaderView.frame = CGRectMake(0, 0, self.tableHeaderView.frame.size.width, self.tableHeaderView.frame.size.height);
        self.myTableView.frame = CGRectMake(0, SCREENHEIGHT, self.myTableView.frame.size.width, self.myTableView.frame.size.height);
        self.backButton.alpha = 1.0;
        self.editButton.alpha = 1.0;
        self.userInfoView.hidden = NO;
        self.userHeadView.hidden = YES;
    } completion:^(BOOL finished) {
        self.myTableView.scrollEnabled = NO;
        [self configButtonBackgroundColor:1000];
    }];
}


//calculate cell height
- (CGFloat)calculateCellHeightForPic:(NSInteger)count
{
    CGFloat height = ceil(count/3.0) * 80;
    return height;
}

//calculate cell height
- (CGFloat)calculateCellHeightForActivity:(NSInteger)count
{
    CGFloat height = 85 *count;
    return height;
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TableViewDataSourceType_Info) {
        return (self.userType == UserTypeSelf ? (self.userInfoArray.count - 1) : self.userInfoArray.count);
    }
    else if (tableView.tag == TableViewDataSourceType_News)
        return self.newsArray.count;
    else if (tableView.tag == TableViewDataSourceType_Activity)
        return self.activityArray.count;
    else
        return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == TableViewDataSourceType_Info) {
        return 0;
    }
    else
    {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    if (tableView.tag == TableViewDataSourceType_Info) {
        headView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
    }
    else
    {
        headView.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewDataSourceType_Info) {
        if (indexPath.row == 6) {
            NSArray *friends = [NSArray arrayWithArray:self.userInfoArray[6]];
            return (friends.count > 6 ? 78 : 39);
        }
        else
        {
            return 49;
        }
    }
    else if (tableView.tag == TableViewDataSourceType_News)
    {
        return [self calculateCellHeightForActivity:((NSArray *)self.newsArray[indexPath.row][@"news"]).count];
    }
    else if (tableView.tag == TableViewDataSourceType_Activity)
    {
        return [self calculateCellHeightForActivity:((NSArray *)self.activityArray[indexPath.row][@"activity"]).count];
    }
    else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewDataSourceType_Info) {
        static NSString *infoCellIndentifier = @"infoCellIndentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellIndentifier];
        }
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        if (indexPath.row == 6) {
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 77, 48)];
            textLabel.font = [UIFont systemFontOfSize:12];
            textLabel.textAlignment = NSTextAlignmentRight;
            textLabel.text = Personal_Info[indexPath.row];
            [cell.contentView addSubview:textLabel];
        }
        else
        {
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 0, 77, 48)];
            textLabel.font = [UIFont systemFontOfSize:12];
            textLabel.textAlignment = NSTextAlignmentRight;
            textLabel.text = Personal_Info[indexPath.row];
            [cell.contentView addSubview:textLabel];
            
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 0, 200, 48)];
            detailLabel.font = [UIFont systemFontOfSize:12];
            detailLabel.textAlignment = NSTextAlignmentLeft;
            detailLabel.text = self.userInfoArray[indexPath.row];
            [cell.contentView addSubview:detailLabel];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView.tag == TableViewDataSourceType_News) {
        static NSString *newsCellIndentifier = @"newsCellIndentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellIndentifier];
        }
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 12)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.text = self.newsArray[indexPath.row][@"time"];
        [cell.contentView addSubview:timeLabel];
        
        NSArray *newsArray = self.newsArray[indexPath.row][@"news"];
        
        
        for (int i = 0; i < newsArray.count; i++) {
            
            NSDictionary *newDic = newsArray[i];
            UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, i*85, 75, 75)];
            headImageView.image = [UIImage imageNamed:newDic[@"image"]];
            [cell.contentView addSubview:headImageView];
            
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, i*85, SCREENWIDTH - 160 - 20, 25)];
            contentLabel.text = newDic[@"content"];
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.textColor = [UIColor blackColor];
            [cell.contentView addSubview:contentLabel];
            
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(160, i*85 + 45, SCREENWIDTH - 160 - 20, 15)];
            titlelabel.textColor = [UIColor lightGrayColor];
            titlelabel.text = newDic[@"title"];
            titlelabel.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:titlelabel];
            
            UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, i*85 + 60, SCREENWIDTH - 160 - 20, 15)];
            locationLabel.textColor = [UIColor lightGrayColor];
            locationLabel.text = newDic[@"location"];
            locationLabel.font = [UIFont systemFontOfSize:12];
            [cell.contentView addSubview:locationLabel];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView.tag == TableViewDataSourceType_Activity) {
        static NSString *activityCellIndentifier = @"activityCellIndentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityCellIndentifier];
        }
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 12)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.text = self.activityArray[indexPath.row][@"time"];
        [cell.contentView addSubview:timeLabel];
        
        NSArray *activityArray = self.activityArray[indexPath.row][@"activity"];
        
        
        for (int i = 0; i < activityArray.count; i++) {
            NSDictionary *activityDic = activityArray[i];
            UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, i*85, 75, 75)];
            headImageView.image = [UIImage imageNamed:activityDic[@"image"]];
            [cell.contentView addSubview:headImageView];
            
            UITextView *activityTextView = [[UITextView alloc]initWithFrame:CGRectMake(155, i*85, SCREENWIDTH - 155 - 20, 75)];
            activityTextView.layer.borderWidth = 1.0f;
            activityTextView.layer.borderColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1.0].CGColor;
            activityTextView.text = activityDic[@"content"];
            activityTextView.font = [UIFont systemFontOfSize:12];
            activityTextView.editable = NO;
            [cell.contentView addSubview:activityTextView];
            
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    else if (tableView.tag == TableViewDataSourceType_Map) {
        return nil;
    }
    return nil;
    
}

@end
