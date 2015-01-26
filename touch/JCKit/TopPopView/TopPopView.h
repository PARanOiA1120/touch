//
//  TopPopView.h
//  jiechu
//
//  Created by jianxd on 15/1/8.
//  Copyright (c) 2015年 jiechu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopPopView;

typedef NS_ENUM(NSInteger, PopViewType) {
    PopViewTypeList = 0,
    PopViewTypeGrid
};

@protocol TopPopViewDelegate <NSObject>

- (NSInteger)numberOfItemsInPopView:(TopPopView *)popView;
- (UIImage *)popView:(TopPopView *)popView imageAtIndex:(NSInteger)index;
- (NSString *)popView:(TopPopView *)popView titleAtIndex:(NSInteger)index;

@optional
- (void)popView:(TopPopView *)popView didSelectItemAtIndex:(NSInteger)index;
- (CGFloat)popView:(TopPopView *)popView heightForItemAtIndex:(NSInteger)index;
@end

@interface TopPopView : UIView

@property (nonatomic) PopViewType viewType;

@property (weak, nonatomic) id<TopPopViewDelegate> delegate;

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic, getter=isShown) BOOL shown;

- (instancetype)initWithViewType:(PopViewType)viewType;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
