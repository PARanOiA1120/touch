//
//  CustomItem.m
//  touch
//
//  Created by jiapeiyao on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
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
