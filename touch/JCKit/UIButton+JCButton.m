//
//  UIButton+JCButton.m
//  jiechu
//
//  Created by jianxd on 14/12/9.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#import "UIButton+JCButton.h"
#import "TouchDefine.h"

#define TYPE_IMAGE_TOP_MARGIN       30.0
#define TYPE_TITLE_BOTTOM_MARGIN    10.0
#define TYPE_TITLE_SIZE             14.0

@implementation UIButton (JCButton)
+ (instancetype)eventTypeButtonWithFramg:(CGRect)frame normalImage:(UIImage *)nImage highlightImage:(UIImage *)hImage text:(NSString *)text {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat imageWidth = CGImageGetWidth(nImage.CGImage) / screenScale;
    CGFloat imageHeight = CGImageGetHeight(nImage.CGImage) / screenScale;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [button setImage:nImage forState:UIControlStateNormal];
    [button setImage:hImage forState:UIControlStateHighlighted];
    [button setImage:hImage forState:UIControlStateSelected];
    [button setTitle:text forState:UIControlStateNormal];
    CGFloat imageLeftInset = (frame.size.width - imageWidth) / 2;
    CGFloat imageTopInset = TYPE_IMAGE_TOP_MARGIN - imageHeight / 2;
    CGFloat imageBottomInset = frame.size.height - imageTopInset - imageHeight;
    button.imageEdgeInsets = UIEdgeInsetsMake(imageTopInset, imageLeftInset, imageBottomInset, imageLeftInset);
    CGSize titleSize = [text sizeWithAttributes:@{NSForegroundColorAttributeName: [UIFont systemFontOfSize:TYPE_TITLE_SIZE]}];
    CGFloat titleTopInset = frame.size.height - TYPE_TITLE_BOTTOM_MARGIN - titleSize.height;
    button.titleEdgeInsets = UIEdgeInsetsMake(titleTopInset, -imageWidth / 2, TYPE_TITLE_BOTTOM_MARGIN, imageWidth / 2);
    [button setTitleColor:RGBCOLOR(54.0, 63.0, 72.0) forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(235.0, 74.0, 56.0) forState:UIControlStateHighlighted];
    [button setTitleColor:RGBCOLOR(235.0, 74.0, 56.0) forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:TYPE_TITLE_SIZE];
    return button;
}
@end
