//
//  StepOneViewController.h
//  touch
//
//  Created by Ariel Xin on 1/13/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "InsetTextField.h"

@interface StepOneViewController : UIViewController
@property (weak, nonatomic) IBOutlet InsetTextField *username;
@property (weak, nonatomic) IBOutlet InsetTextField *password;
@property (weak, nonatomic) IBOutlet InsetTextField *confirmPW;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@end
