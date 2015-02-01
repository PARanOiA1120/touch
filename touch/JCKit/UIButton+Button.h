//
//  UIButton+Button.h
//  touch
//
//  Created by Ariel Xin on 2/1/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Button)
+ (instancetype)eventTypeButtonWithFramg:(CGRect)frame normalImage:(UIImage *)nImage highlightImage:(UIImage *)hImage text:(NSString *)text;
@end
