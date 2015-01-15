//
//  StepTwoViewController.m
//  touch
//
//  Created by Ariel Xin on 1/15/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "StepTwoViewController.h"
#import "IHKeyboardAvoiding.h"
#import "CommonDefine.h"
#import "InsetTextField.h"

@interface StepTwoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet InsetTextField *major;


@end

@implementation StepTwoViewController

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
