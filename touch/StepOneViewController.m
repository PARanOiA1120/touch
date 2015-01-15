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
#import "RegisterViewController.h"
#import "IntroViewController.h"

@interface StepOneViewController ()
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelRegister:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)nextStep:(id)sender {
    StepTwoViewController *registerController = [[StepTwoViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
    //registerController.title=@"Registration 2/2";
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
