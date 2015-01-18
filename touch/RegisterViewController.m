//
//  RegisterViewController.m
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController ()<UITextFieldDelegate> { CGPoint _originOffset; }
@property (nonatomic, strong)UITextField *usernameField;
@property (nonatomic, strong)UITextField *passwordField;
@property (nonatomic, strong)UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.view = view;
    
    [self configView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (SCREEN_HEIGHT <= 480) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    _originOffset = scrollView.contentOffset;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void) configView {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle: @"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = item;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:pan];
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    originX = 15;
    originY = (SCREEN_HEIGHT<=480)?100:130;
    width = SCREEN_WIDTH - originX*2;

    height = 50;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(originX, originY, width, height)];

    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.backgroundColor=RGBACOLOR(236, 240, 241, 0.5);
    textField.placeholder = @"用户名";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyNext;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    self.usernameField = textField;
    
    originY += height+7;

    height = 50;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(originX, originY, width, height)];

    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.backgroundColor=RGBACOLOR(236, 240, 241, 0.5);
    textField.placeholder = @"密码";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    textField.secureTextEntry = YES;
    textField.returnKeyType = UIReturnKeyGo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    self.passwordField = textField;
    
    originY += height + 7;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(originX, originY, width, height);
    [button setBackgroundColor:RGBACOLOR(184, 150, 101, 1)];

    button.enabled = NO;
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [button addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.registerButton = button;
}


#pragma actions


- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

-(IBAction)registerUser:(id)sender
{
    NSLog(@"now registering");
}

- (void)closeKeyboard:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)changeButtonState:(NSNotification *)notification{
    UIButton *button = self.registerButton;
    if(self.usernameField.text.length >= USERNAME_MIN_LENGTH && self.passwordField.text.length >= PASSWORD_MIN_LENGTH){
        button.enabled = YES;
    }else {
        button.enabled = NO;
    }
}
#pragma mark - Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    [self performSelector:@selector(moveUpMainView) withObject:nil afterDelay:0.1];
}


- (void)keyboardWillHide:(NSNotification *)notification{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentOffset:_originOffset animated:YES];
}

- (void)moveUpMainView{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentOffset:CGPointMake(0, 65) animated:YES];
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
