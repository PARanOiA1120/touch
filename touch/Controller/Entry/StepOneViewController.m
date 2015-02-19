//
//  StepOneViewController.m
//  touch
//
//  Created by Ariel Xin on 1/13/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "StepOneViewController.h"
#import "IHKeyboardAvoiding.h"
#import "InsetTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "StepTwoViewController.h"
#import "IntroViewController.h"
#import "ProgressHUD.h"
#import "User.h"


@interface StepOneViewController () <UIScrollViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet InsetTextField *username;
@property (weak, nonatomic) IBOutlet InsetTextField *password;
@property (weak, nonatomic) IBOutlet InsetTextField *confirmPW;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end

@implementation StepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:pan];

    self.password.secureTextEntry = YES;
    self.confirmPW.secureTextEntry = YES;
}

- (void)closeKeyboard:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPW resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Back to IntroViewController when "back" button is tapped
- (IBAction)cancelRegister:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//If user entered username has more than two chars, password has more than 5 chars,
//and the two password match, go to StepTwoViewController
- (IBAction)nextStep:(id)sender{
    if(self.username.text.length <3 ){
        [ProgressHUD showError:@"Please enter a username"];
        [self.username becomeFirstResponder];
        return;
    }
    if(self.password.text.length<6){
        [ProgressHUD showError:@"Please enter a password"];
        [self.password becomeFirstResponder];
        return;
    }
    if(self.confirmPW.text.length<6){
        [ProgressHUD showError:@"Please confirm the password"];
        [self.confirmPW becomeFirstResponder];
        return;
    }
    
    User *user = [User currentUser];
    user.username = self.username.text;
    if (![self.password.text isEqualToString:self.confirmPW.text]){
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Alert！" message:@"Password not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [errorAlertView show];
        return;
    }
    user.password = self.password.text;
    
    StepTwoViewController *registerController = [[StepTwoViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
    
}

@end
