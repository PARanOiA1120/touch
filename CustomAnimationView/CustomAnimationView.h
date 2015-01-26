//
//  CustomAnimationView.h
//  AnimationDemo
//
//  Created by xuxingdu on 14/10/28.
//  Copyright (c) 2014年 AI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomItem;
@class VBFPopFlatButton;
static const CGFloat kCustomAnimationViewOffset = 20;

@protocol CustomAnimationViewDelegate <NSObject>

@required

- (void)dismissCustomAnimationView;

- (void)itemClicked:(CustomItem *)item;

@end

@interface CustomAnimationView : UIView
@property (strong,nonatomic) NSArray *buttonItems;
@property (nonatomic, assign) id <CustomAnimationViewDelegate>   delegate;
@property (strong, nonatomic) VBFPopFlatButton *dismissBtn;


- (void)layoutItems;
- (void)beginAnimations;
@end
