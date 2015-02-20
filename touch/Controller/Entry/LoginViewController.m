//
//  LoginViewController.m
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "LoginViewController.h"
#import "IHKeyboardAvoiding.h"
#import "CommonDefine.h"
#import "ProgressHUD.h"
#import "User.h"
#import "AppDelegate.h"

@interface LoginViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *avoidingView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet InsetTextField *userNameField;
@property (weak, nonatomic) IBOutlet InsetTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPHONE_5){
        [IHKeyboardAvoiding setKeyboardAvoidingMode:KeyboardAvoidingModeMinimumDelayed];
        [IHKeyboardAvoiding setAvoidingView:self.avoidingView withTriggerView:self.userNameField];
        [IHKeyboardAvoiding setAvoidingView:self.avoidingView withTriggerView:self.passwordField];
        [IHKeyboardAvoiding setPadding:10];
    }
    if (IS_IPHONE_4_OR_LESS){
        [IHKeyboardAvoiding setKeyboardAvoidingMode:KeyboardAvoidingModeMinimumDelayed];
        [IHKeyboardAvoiding setAvoidingView:self.avoidingView withTriggerView:self.userNameField];
        [IHKeyboardAvoiding setAvoidingView:self.avoidingView withTriggerView:self.passwordField];
        [IHKeyboardAvoiding setPadding:10];
    }
    
    self.passwordField.secureTextEntry=YES;
    [self configView];
    self.backButton.layer.cornerRadius = self.backButton.frame.size.height/2;
    self.backButton.layer.masksToBounds = YES;
}

//back to the IntroViewController if "back" button tapped

- (IBAction)backToIntro:(id)sender {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[AppDelegate delegate] goToIntro];
}

//We haven't implemented the following four methods
- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)loginWithFacebook:(id)sender {
}

- (IBAction)loginWithTwitter:(id)sender {
}

- (IBAction)loginWithInstagram:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)configView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:pan];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ICON_CACHED"]) {
        NSData *imageData=[[NSUserDefaults standardUserDefaults] objectForKey:@"IconCache"];
        [self.iconImageView setImage:[UIImage imageWithData:imageData]];
        
        self.iconImageView.layer.borderWidth = 3.0;
        self.iconImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height/2;;
    };
    
}

#pragma model
- (IBAction)login:(id)sender {
    //If username is less then 3 chars, pop an alert view
    if(!self.userNameField.text || (self.userNameField.text.length<3)){
        [ProgressHUD showError:@"Please enter username"];
        [self.userNameField becomeFirstResponder];
        return;
    }
    //If password is less then 6 chars, pop an alert view
    if (!self.passwordField.text || (self.passwordField.text.length < 6))
    {
        [ProgressHUD showError:@"Please enter password"];
        [self.passwordField becomeFirstResponder];
        return;
    }
    [ProgressHUD show:@"Logging in now" Interaction:NO];
    
    User *user = [User currentUser];
    //check if password is correct in database
    [user logInWithUsernameInBackground:self.userNameField.text password:self.passwordField.text block:^(BOOL succeeded, NSError *error){
        if (succeeded){
            [ProgressHUD showSuccess:@"Login succeeded"];
            [self closeKeyboard];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate createTabBar];
        }else{
            [ProgressHUD dismiss];
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

//tap anywhere to hide the keyboard
//note: there is no keyboard pops up when testing using the simulator
- (void)closeKeyboard {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 0){
        [self.passwordField becomeFirstResponder];
    }else if(textField.tag == 1){
        NSLog(@"tapped");
        [self.passwordField resignFirstResponder];
        [self login:self];
    }
    return YES;
}

@end