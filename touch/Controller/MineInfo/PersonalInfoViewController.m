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
#import "ActionSheetDatePicker.h"
#import "IHKeyboardAvoiding.h"
#import "ProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ProgressHUD.h"
#import "UINavigationController+SGProgress.h"
#import "ActionsheetStringPicker.h"
#import "CommonDefine.h"

#define ORIGINAL_MAX_WIDTH 640.0f

#define PersonalInfoTitle @[@[@"昵称",@"性别",@"生日"],@[@"职业",@"公司",@"学校",@"邮箱"]]
#define PersonalInfoKey @[@[@"name",@"sex",@"birthday"],@[@"job",@"workplace",@"school",@"email"]]
@interface PersonalInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) ActionSheetDatePicker *actionSheetPicker;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *squareImage;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
//@property (strong, nonatomic) JCUser *user;
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
    self.title = @"编辑资料";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAllKeyBoard)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.tableHeadView addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdition:)];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.selectedDate = [self.dateFormatter dateFromString:@"1990-01-01"];
    NSLog(@"did load");
    //self.user = [JCUser currentUser];
    /*[self.user getSmallUserAvatarWithUserID:self.user.recordID andWidth:self.headImageView.frame.size.width andHeight:self.headImageView.frame.size.height andBlock:^(UIImage *image, NSError *error) {
        if (image) {
            self.headImageView.image = image;
        }
    }];*/
    
    /*[self.user getTextInformation:^(BOOL succeeded, NSError *error) {
        [self.myTableView reloadData];
    }];*/
    self.isNewImage = NO;
}

- (void)closeAllKeyBoard
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}



- (void)finishEdition:(id)sender
{
    if ([self getInfoValue:[NSIndexPath indexPathForRow:0 inSection:0]].length == 0)
    {
        [ProgressHUD showError:@"缺少名字"];
        return;
    }
    [self closeAllKeyBoard];
    //self.user.name = [self getInfoValue:[NSIndexPath indexPathForRow:0 inSection:0]];
    //self.user.sex = [self getInfoValue:[NSIndexPath indexPathForRow:1 inSection:0]];
    //self.user.birthday = [self getInfoValue:[NSIndexPath indexPathForRow:2 inSection:0]];
    //self.user.job = [self getInfoValue:[NSIndexPath indexPathForRow:0 inSection:1]];
    //self.user.workPlace = [self getInfoValue:[NSIndexPath indexPathForRow:1 inSection:1]];
    //self.user.school = [self getInfoValue:[NSIndexPath indexPathForRow:2 inSection:1]];
    //have some problem with email
    //self.user.email = [self getInfoValue:[NSIndexPath indexPathForRow:3 inSection:1]];
    if (self.isNewImage)
    {
        //self.user.largeImage = self.selectedImage;
        //self.user.squareImage = self.squareImage;
        
        /*[self.user updateUserInfo:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                [ProgressHUD showSuccess:@"更新成功"];
                //now need to dismiss this view controller and notify the personal home page and setting page to get ready to update full information
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedFullInfo" object:self];
                NSLog(@"going back now");
                [self.navigationController popViewControllerAnimated:YES];
                
                NSData *squareData = UIImagePNGRepresentation(self.squareImage);
                [[NSUserDefaults standardUserDefaults] setObject:squareData forKey:@"IconCache"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ICON_CACHED"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                [ProgressHUD showError:@"网络异常！"];
            }
        }
                      percentDone:^(NSInteger percent)
         {
             NSNumber *temp = [NSNumber numberWithInteger:percent];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.navigationController setSGProgressMaskWithPercentage:[temp floatValue]];
             });
         }
                    squarePercent:^(NSInteger percentage) {
                        NSNumber *tempo = [NSNumber numberWithInteger:percentage];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController setSGProgressMaskWithPercentage:[tempo floatValue]];
                        });
                    }];
    }
    //User did not change the photo just edited some parts
    else
    {
        [self.user updateUserInfoWithoutImage:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                //now need to dismiss this view controller and notify the personal home page and setting page to get ready to update some information
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedTextInfo" object:self];
                NSLog(@"going back now 2");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];*/
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        //cell.valueTextField.text = self.user.name;
    }
    else if (indexPath.section == 0 & indexPath.row == 1)
    {
        //cell.valueTextField.text = self.user.sex;
        cell.valueTextField.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 0 & indexPath.row == 2)
    {
        //cell.valueTextField.text = self.user.birthday;
        cell.valueTextField.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 1 & indexPath.row == 0)
    {
        //cell.valueTextField.text = self.user.job;
    }
    else if (indexPath.section == 1 & indexPath.row == 1)
    {
        //cell.valueTextField.text = self.user.workPlace;
    }
    else if (indexPath.section == 1 & indexPath.row == 2)
    {
        //cell.valueTextField.text = self.user.school;
    }
    else if (indexPath.section == 1 & indexPath.row == 3)
    {
        //cell.valueTextField.text = self.user.email;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.valueTextField.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 & indexPath.row == 1)
    {
        //弹出性别选择框
        [self closeAllKeyBoard];
        self.sexCell = (PersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
        ActionSheetStringPicker *sexPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择性别" rows:@[@"男",@"女"] initialSelection:0 target:self successAction:@selector(doneSelection:element:) cancelAction:@selector(canceled:) origin:self.sexCell.valueTextField];
        [sexPicker showActionSheetPicker];
    }
    else if (indexPath.section == 0 & indexPath.row == 2)
    {
        //弹出日期选择框
        //        _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:nil];
        
        //        self.actionSheetPicker.hideCancel = NO;
        //        [self.actionSheetPicker showActionSheetPicker];
        [self closeAllKeyBoard];
        PersonInfoCell *cell = (PersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
        [ActionSheetDatePicker showPickerWithTitle:@""
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:self.selectedDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                          cell.valueTextField.text = [self.dateFormatter stringFromDate:selectedDate];
                                      } cancelBlock:^(ActionSheetDatePicker *picker) {
                                          
                                      }
                                            origin:cell];
        
    }
}


- (void)doneSelection:(NSNumber *)selectedIndex element:(id)element
{
    if ([selectedIndex intValue] == 0)
    {
        self.sexCell.valueTextField.text = @"male";
    }
    else
    {
        self.sexCell.valueTextField.text = @"female";
    }
}

- (void)canceled:(id)sender
{
    
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - ADDING PORTRAIT

- (void)editPortrait
{
    //NSLog(@"tapped");
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}



@end

