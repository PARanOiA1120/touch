//
//  CustomActionSheet.h
//  jiechu
//
//  Created by xuxingdu on 14/12/28.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheet : UIView
@property (strong, nonatomic) UIView *customView;


- (id)initWithCustomView:(UIView *)view;
- (void)show;
- (void)hide;
@end
