//
//  IntroViewController.m
//  touch
//
//  Created by Ariel Xin on 1/11/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "IntroViewController.h"
#import "LoginViewController.h"
#import "StepOneViewController.h"
#import "StepTwoViewController.h"

@interface IntroViewController () <ICETutorialControllerDelegate>

@end

@implementation IntroViewController

-(instancetype)init{
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"How to meet instructors?"
                                                            subTitle:@"Use touch to make appointments!"
                                                         pictureName:@"meet@2x.png"
                                                            duration:3.5];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"Stuck with homework?"
                                                            subTitle:@"Invite classmates to study together!"
                                                         pictureName:@"study@2x.png"
                                                            duration:3.5];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"When to hold review session?"
                                                            subTitle:@"Ask students when they are available!"
                                                         pictureName:@"review@2x.png"
                                                            duration:3.5];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"Partners recruiting?"
                                                            subTitle:@"Ask who is intrested!"
                                                         pictureName:@"partner@2x.png"
                                                            duration:3.5];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"Touch"
                                                            subTitle:@"Best way to get in touch with\n people when you are in need!"
                                                         pictureName:@"touch@2x.png"
                                                            duration:3.5];

    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:19.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    self = [super initWithPages:tutorialLayers delegate:self];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startScrolling];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
    [self toLogin];
}

- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
    [self toRegister];
}

//go to the LoginViewController when "Login" button is tapped
- (void)toLogin{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate goToLogin];
}

//go to StepOneViewController when "Register" button is tapped
- (void)toRegister{
    [self stopScrolling];
    StepOneViewController *registerController = [[StepOneViewController alloc] init];
    UINavigationController *registerNav = [[UINavigationController alloc] initWithRootViewController:registerController];
    [self presentViewController:registerNav animated:YES completion:^{
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

