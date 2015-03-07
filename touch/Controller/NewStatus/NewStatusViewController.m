//
//  NewStatusViewController.m
//  touch
//
//  Created by Ariel Xin on 2/1/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "NewStatusViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "newsFeedManager.h"
#import "newsFeed.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "Event.h"
#import "CommonDefine.h"
#import "SZTextView.h"

@interface NewStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *photoView;
@property (strong, nonatomic) SZTextView *inputView;
@property (strong, nonatomic) UIImageView *profileView;
@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (nonatomic) CGFloat imageSize;
@property (nonatomic) CGFloat imageSpacing;
@property (nonatomic) CGFloat imageLeftMargin;
@property (strong, nonatomic) UIImage *image;


@end

@implementation NewStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    [self configureTableHeaderView];
    [self configureTableFooterView];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0.0, -SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT + 1);
    view.backgroundColor = [UIColor whiteColor];
    [_tableView addSubview:view];
    _tableView.separatorInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 0.0);
    if (!_selectedImages) {
        self.selectedImages = [[NSMutableArray alloc] init];
    }
    if (SCREENWIDTH == 320.0) {
        self.imageLeftMargin = 5.0;
        self.imageSize = 65.0;
        self.imageSpacing = 10.0;
    } else if (SCREENWIDTH == 375.0) {
        self.imageLeftMargin = 5.0;
        self.imageSize = 70.0;
        self.imageSpacing = 15.0;
    } else {}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDidClick:)];
    buttonItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = buttonItem;
    buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonDidClick:)];
    buttonItem.tintColor = [UIColor redColor];
}

-(void)addButtonDidClick:(UIButton *)Button{}

- (void)tapBackground:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)cancelButtonDidClick:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configureTableHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 40.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, SCREENWIDTH - 30.0, 20.0)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"Say something...";
    [view addSubview:label];
    _tableView.tableHeaderView = view;
}

//Hard-coded UI to add the "post" button
- (void)configureTableFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 60.0)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(7.0, 10.0, SCREENWIDTH - 20.0, 46.0)];
    [button addTarget:self action:@selector(createNewsFeed:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_yellow.png"] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"send", @"post") forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(184.0, 150.0, 101.0) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [view addSubview:button];
    _tableView.tableFooterView = view;
}

//post to newsfeed
//We're still working on posting status to backend
- (void)createNewsFeed:(UIButton *)button {
    if ([_inputView.text isEqualToString:@""]) {
        return;
    }
    NSLog(@"reach?");
    newsFeed *nf = [[newsFeed alloc] init];
    nf.eventType = 1;
    nf.content = _inputView.text;
    [[newsFeedManager sharedManager] createNewsFeed:nf];


            NSLog(@"create news feed success");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:UIActivityCircleNeedRefreshDataNotification object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [[AppDelegate delegate] selectTab:0];
                }];
            });

    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark -- Table view data source
//create a table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
        SZTextView *textView = [[SZTextView alloc] initWithFrame:CGRectMake(16.0, 5.0, SCREENWIDTH - 32.0, 104.0)];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:13.0];
        textView.tag = 102;
        [cell.contentView addSubview:textView];
        UIView *containerView = [[UIView alloc] init];
        containerView.tag = 103;
        self.inputView = textView;
        [cell.contentView addSubview:containerView];
    }
    SZTextView *textView = (SZTextView *)[cell.contentView viewWithTag:102];
    textView.hidePlaceholderOnTouch = YES;
    textView.placeholder = @"Anything special...";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        return 114.0;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return _imageSize + _imageSpacing * 2;
    } else if (section == 1) {
        return 110.0;
    }
    return 0.0;
}


#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
