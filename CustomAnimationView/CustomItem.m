//
//  CustomItem.m
//  AnimationDemo
//
//  Created by xuxingdu on 14/10/28.
//  Copyright (c) 2014年 AI. All rights reserved.
//

#import "CustomItem.h"

@implementation CustomItem


- (id)initWithImageName:(NSString *)imageName
{
    self = [self initWithFrame:CGRectMake(0, 0, kCustomItemLengthOfSide, kCustomItemLengthOfSide)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1.0];
        self.layer.cornerRadius = kCustomItemLengthOfSide/2;
        self.layer.masksToBounds = YES;
        [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    return self;
}
@end
