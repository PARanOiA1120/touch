//
//  TempMineInfoViewController.m
//  touch
//
//  Created by CharlesYJP on 2/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "TempMineInfoViewController.h"
#import "PersonalHomepageViewController.h"

@interface TempMineInfoViewController ()

@end

@implementation TempMineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toPersonalPage:(id)sender {
    PersonalHomepageViewController *ppage = [[PersonalHomepageViewController alloc] init];
    [self presentViewController:ppage animated:YES completion:^{
    }];

}

@end
