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

@interface StepOneViewController ()
@property (weak, nonatomic) IBOutlet InsetTextField *username;
@property (weak, nonatomic) IBOutlet InsetTextField *password;
@property (weak, nonatomic) IBOutlet InsetTextField *confirmPW;
@property (weak, nonatomic) IBOutlet UIButton *next;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
