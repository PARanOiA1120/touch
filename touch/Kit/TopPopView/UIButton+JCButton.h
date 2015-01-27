//
//  UIButton+JCButton.h
//  touch
//
//  Created by zhu on 1/26/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JCButton)
+ (instancetype)eventTypeButtonWithFramg:(CGRect)frame normalImage:(UIImage *)nImage highlightImage:(UIImage *)hImage text:(NSString *)text;
@end
