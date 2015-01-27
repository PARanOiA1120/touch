//
//  JCAlertView.m
//  jiechu
//
//  Created by jianxd on 14/12/30.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#import "JCAlertView.h"
#import "DRNRealTimeBlurView.h"
#import "TouchDefine.h"

@interface JCAlertView ()

@property (strong, nonatomic) NSString *positiveTitle;
@property (strong, nonatomic) NSString *cancelTitle;

@property (weak, nonatomic) UIView *parentView;
@property (strong, nonatomic) DRNRealTimeBlurView *backBlurView;
@property (strong, nonatomic) UIView *contentWrapperView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *positiveButton;
@property (strong, nonatomic) NSMutableArray *otherButtons;
@end

@implementation JCAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (instancetype)initWithPositiveButtonTitle:(NSString *)positiveTitle cancelButtonTitle:(NSString *)cancelTitle {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    if (self) {
        self.positiveTitle = positiveTitle;
        self.cancelTitle = cancelTitle;
        [self configViews];
    }
    return self;
}

- (instancetype)initWithPositiveButtonTitle:(NSString *)positiveTitle cancelButtonTitle:(NSString *)cancelTitle positiveButtonClick:(PositiveClickBlock)positive cancelButtonClick:(CancelClickBlcok)cancel otherButtonClick:(OtherClickBlcok)other {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    if (self) {
        self.positiveTitle = positiveTitle;
        self.cancelTitle = cancelTitle;
        self.positiveBlock = positive;
        self.cancelBlock = cancel;
        self.otherBlock = other;
        [self configViews];
    }
    return self;
}

- (void)configViews {
    UIColor *tintColor = [UIColor blackColor];
    DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0) tintColor:tintColor];
    blurView.backgroundColor = tintColor;
//    blurView.backgroundColor = [UIColor blackColor];
//    blurView.tintColor = [UIColor blackColor];
    blurView.tint = tintColor;
    blurView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [blurView addGestureRecognizer:tapRecognizer];
    [self addSubview:blurView];
    self.backBlurView = blurView;
    
    UIView *wrapView = [[UIView alloc] init];
//    wrapView.backgroundColor = [UIColor whiteColor];
    wrapView.backgroundColor = [UIColor redColor];
    [blurView addSubview:wrapView];
    self.contentWrapperView = wrapView;
    // 取消按钮
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_yellow.png"] forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(184.0, 150.0, 101.0) forState:UIControlStateNormal];
    [wrapView addSubview:button];
    self.cancelButton = button;
    
    // Positive按钮
    button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_red.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wrapView addSubview:button];
    self.positiveButton = button;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    self.frame = view.bounds;
//    [self layoutSubviews];
    [self configSubviews];
    _backBlurView.alpha = 0.0;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _backBlurView.alpha = 1.0;
                         CGRect contentFrame = _contentWrapperView.frame;
                         _contentWrapperView.frame = CGRectMake(0.0, CGRectGetHeight(self.frame) - CGRectGetHeight(contentFrame), CGRectGetWidth(contentFrame), CGRectGetHeight(contentFrame));
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)tapBackground:(UIGestureRecognizer *)gestureRecognizer {
    [self hide];
}

- (void)configSubviews {
    _backBlurView.frame = self.bounds;
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat offsetY = 10.0;
    if (_otherButtons.count > 0) {
        [_otherButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = obj;
            button.frame = CGRectMake(viewWidth / 4 * idx, offsetY, viewWidth / 4, 60.0);
        }];
        offsetY += 60.0;
    }
    
    if (_positiveTitle && _positiveTitle.length > 0) {
        _positiveButton.hidden = NO;
        _positiveButton.frame = CGRectMake(10.0, offsetY + 10.0, viewWidth - 20.0, 50.0);
        [_positiveButton setTitle:_positiveTitle forState:UIControlStateNormal];
        offsetY += 60.0;
    }
    
    if (_cancelTitle && _cancelTitle.length > 0) {
        _cancelButton.hidden = NO;
        _cancelButton.frame = CGRectMake(10.0, offsetY + 10.0, viewWidth - 20.0, 50.0);
        [_cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        offsetY += 60.0;
    }
    _contentWrapperView.frame = CGRectMake(0.0, CGRectGetHeight(self.frame), viewWidth, offsetY + 20.0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _backBlurView.frame = self.bounds;
//    
//    CGFloat viewWidth = CGRectGetWidth(self.bounds);
//    CGFloat offsetY = 10.0;
//    if (_otherButtons.count > 0) {
//        [_otherButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            UIButton *button = obj;
//            button.frame = CGRectMake(viewWidth / 4 * idx, offsetY, viewWidth / 4, 60.0);
//        }];
//        offsetY += 60.0;
//    }
//    
//    if (_positiveTitle && _positiveTitle.length > 0) {
//        _positiveButton.hidden = NO;
//        _positiveButton.frame = CGRectMake(10.0, offsetY + 10.0, viewWidth - 20.0, 50.0);
//        offsetY += 60.0;
//    }
//    
//    if (_cancelTitle && _cancelTitle.length > 0) {
//        _cancelButton.hidden = NO;
//        _cancelButton.frame = CGRectMake(10.0, offsetY + 10.0, viewWidth - 10.0, 50.0);
//        offsetY += 60.0;
//    }
//    _contentWrapperView.frame = CGRectMake(0.0, CGRectGetHeight(self.frame), viewWidth, offsetY + 20.0);
//    NSLog(@"before1 : %@", NSStringFromCGRect(CGRectMake(0.0, CGRectGetHeight(self.frame), viewWidth, offsetY + 20.0)));
}

- (void)addButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage {
    if (_otherButtons == nil) {
        self.otherButtons = [NSMutableArray array];
    }
    UIButton *button = [[UIButton alloc] init];
    [_otherButtons addObject:button];
    NSUInteger index = [_otherButtons indexOfObject:button];
    button.tag = index;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(184.0, 150.0, 101.0) forState:UIControlStateNormal];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button addTarget:self action:@selector(didClickOtherButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickOtherButton:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(alertView:didClickOtherButtonAtIndex:)]) {
        [_delegate alertView:self didClickOtherButtonAtIndex:button.tag];
    }
    if (_otherBlock) {
        _otherBlock(button.tag);
    }
}

- (void)animateShowBackground {
    
}

- (void)animateShowContentView {
    
}

@end
