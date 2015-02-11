//
//  TempMineInfoViewController2.m
//  touch
//
//  Created by zhu on 2/10/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "TempMineInfoViewController2.h"
#import "NewInfoViewController.h"
#import "IntroViewController.h"

@interface TempMineInfoViewController2 ()

@end

@implementation TempMineInfoViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toNewInfoPage:(id)sender {
     NewInfoViewController *ppage = [[NewInfoViewController alloc] init];
    [self presentViewController:ppage animated:YES completion:^{
    }];
    
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
