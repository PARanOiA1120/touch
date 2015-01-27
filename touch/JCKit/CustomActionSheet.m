//
//  CustomActionSheet.m
//  jiechu
//
//  Created by xuxingdu on 14/12/28.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#import "CustomActionSheet.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
@implementation CustomActionSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCustomView:(UIView *)view
{
    self = [self initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
        if (view) {
            _customView = view;
            _customView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, view.frame.size.height);
            [self addSubview:_customView];
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    return self;
}

- (void)show
{
    [[[AppDelegate delegate] window] addSubview:self];
    if (_customView) {
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _customView.frame = CGRectMake(0, SCREENHEIGHT - _customView.frame.size.height, SCREENWIDTH, _customView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hide
{
    if (_customView) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _customView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, _customView.frame.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)tapAction
{
    [self hide];
}

@end
