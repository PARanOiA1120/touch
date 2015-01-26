//
//  UIButton+JCButton.h
//  jiechu
//
//  Created by jianxd on 14/12/9.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JCButton)
+ (instancetype)eventTypeButtonWithFramg:(CGRect)frame normalImage:(UIImage *)nImage highlightImage:(UIImage *)hImage text:(NSString *)text;
@end
