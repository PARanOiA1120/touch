//
//  CustomItem.h
//  AnimationDemo
//
//  Created by xuxingdu on 14/10/28.
//  Copyright (c) 2014年 AI. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ItemFuncion @[@"Event",@"Status",@"Photo",@"Video",@"Sign in"]
typedef NS_ENUM(NSInteger, Function_type)
{
    Function_type_activity = 0,
    Function_type_video,
    Function_type_photo,
    Function_type_state,
    Function_type_signIn
};
static const CGFloat kCustomItemLengthOfSide = 100;

@interface CustomItem : UIButton
@property(nonatomic)CGPoint startPoint;
@property(nonatomic)CGPoint endPoint;
@property(nonatomic)Function_type function;

- (id)initWithImageName:(NSString *)imageName;
@end
