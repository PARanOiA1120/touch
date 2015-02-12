//
//  BlackListViewController.m
//  touch
//
//  Created by CharlesYJP on 2/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "BlackListViewController.h"
#import "BlackCell.h"
#import <UIButton+WebCache.h>
#import "CommonDefine.h"
@interface BlackListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"黑名单";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"BlackCell" bundle:nil] forCellReuseIdentifier:@"BlackCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BlackCell";
    BlackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell.headButton setImage:[UIImage imageNamed:@"personal_activity_head.png"] forState:UIControlStateNormal];
    cell.nameLabel.text = @"xxxxx";
    [cell.functionButton setTitle:@"移出" forState:UIControlStateNormal];
    //[cell.functionButton setBackgroundColor:RGBACOLOR(186, 186, 186, 1)];
    [cell.functionButton setBackgroundColor:[UIColor colorWithRed:(186/255.0) green:(186/255.0) blue:(186/255.0) alpha:1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
