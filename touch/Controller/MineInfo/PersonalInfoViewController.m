//
//  PersonalInfoViewController.m
//  touch
//
//  Created by CharlesYJP on 2/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "User.h"
#import "PersonInfoCell.h"
#import "IHKeyboardAvoiding.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ProgressHUD.h"
#import "UINavigationController+SGProgress.h"
#import "CommonDefine.h"

#define ORIGINAL_MAX_WIDTH 640.0f
#define PersonalInfoTitle @[@[@"Name",@"Gender",@"Major", @"Class Level"],@[@"Skill"]]

@interface PersonalInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) UIImage *squareImage;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) PersonInfoCell *sexCell;
@property (nonatomic) BOOL isNewImage;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.height/2;
    self.headImageView.layer.borderWidth = 3.0f;
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    portraitTap.numberOfTapsRequired = 1;
    [self.headImageView addGestureRecognizer:portraitTap];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"PersonInfoCell" bundle:nil] forCellReuseIdentifier:@"PersonInfoCell"];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView setTableHeaderView:self.tableHeadView];
    self.title = @"Edit";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAllKeyBoard)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.tableHeadView addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdition:)];
    self.headImageView.image = [UIImage imageNamed:@"mine_head.png"];

    self.isNewImage = NO;
}

- (void)closeAllKeyBoard{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (NSString *)getInfoValue:(NSIndexPath *)indexPath
{
    PersonInfoCell *cell = (PersonInfoCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    return cell.valueTextField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & UItableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return PersonalInfoTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)PersonalInfoTitle[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"PersonInfoCell";
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.titleLabel.text = PersonalInfoTitle[indexPath.section][indexPath.row];
    if (indexPath.section == 0 & indexPath.row == 0) {
        cell.valueTextField.text = self.user.username;
    }
    else if (indexPath.section == 0 & indexPath.row == 1)
    {
        cell.valueTextField.text = self.user.gender;
        cell.valueTextField.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 0 & indexPath.row == 2){
        cell.valueTextField.text = self.user.major;
        cell.valueTextField.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 0 & indexPath.row == 3)
    {
        cell.valueTextField.text = self.user.classlevel;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.valueTextField.delegate = self;
    return cell;
}



@end

