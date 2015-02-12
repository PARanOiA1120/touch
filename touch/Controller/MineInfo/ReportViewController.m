//
//  ReportViewController.m
//  touch
//
//  Created by CharlesYJP on 2/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//


#import "ReportViewController.h"
#import "CommonDefine.h"


@interface ReportViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"举报";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 30, SCREENWIDTH - 20, 50);
    button.backgroundColor = [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    [_tableView setTableFooterView:footerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataSource = [@[
                     @{
                         @"selected":@(NO),
                         @"name":@"色情"
                         },
                     @{
                         @"selected":@(NO),
                         @"name":@"政治"
                         },
                     @{
                         @"selected":@(NO),
                         @"name":@"垃圾营销"
                         },
                     @{
                         @"selected":@(NO),
                         @"name":@"对他人造成危害"
                         }
                     ]mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sureBtnClicked:(UIButton *)button
{
    NSLog(@"举报 确定按钮点击");
}


//关闭键盘
-(void) dismissKeyBoard{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else
    {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return SCREENHEIGHT - 64 - 6 * 43 - 100;
    }
    else
    {
        return 43;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    else
    {
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, SCREENHEIGHT - 64 - 6 * 43 - 100)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.userInteractionEnabled = YES;
        _textView.delegate = self;
        UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
        [topView setItems:buttonsArray];
        [_textView setInputAccessoryView:topView];
        
        [cell.contentView addSubview:_textView];
    }
    else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:_dataSource[indexPath.row]];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 22, 22)];
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = 11;
        icon.image = [dic[@"selected"]boolValue] ? [UIImage imageNamed:@"report_icon_red.png"] : [UIImage imageNamed:@"report_icon_gray.png"];
        
        [cell.contentView addSubview:icon];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREENWIDTH - 60 - 10, 43)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = dic[@"name"];
        [cell.contentView addSubview:titleLabel];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *dic = _dataSource[indexPath.row];
        NSDictionary *temp = @{@"selected":@(![dic[@"selected"]boolValue]),@"name":dic[@"name"]};
        [_dataSource replaceObjectAtIndex:indexPath.row withObject:temp];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"举报的原因";
    }
    else if (section == 1)
    {
        return @"补充的话";
    }
    return nil;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
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
