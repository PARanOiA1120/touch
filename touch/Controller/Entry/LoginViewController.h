//
//  LoginViewController.h
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "InsetTextField.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *avoidingView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet InsetTextField *userNameField;
@property (weak, nonatomic) IBOutlet InsetTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookLogin;

@end