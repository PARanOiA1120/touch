//
//  tempMineInfoViewController.m
//  touch
//
//  Created by CharlesYJP on 2/7/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "tempMineInfoViewController.h"
#import "PersonalHomepageViewController.h"

@interface tempMineInfoViewController ()
@end

@implementation tempMineInfoViewController
@synthesize ButtonToPP;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterPersonalPage:(id)sender {
    NSLog(@"Button Pressed");

}

-(IBAction)gotoPersonalPage:(id)sender {
    NSLog(@"Button Pressed");
    //PersonalHomepageViewController *pp=[[PersonalHomepageViewController alloc] init];
    //[self presentViewController:pp animated:YES completion:^{
    //}];
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
