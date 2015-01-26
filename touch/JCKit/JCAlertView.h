//
//  JCAlertView.h
//  jiechu
//
//  Created by jianxd on 14/12/30.
//  Copyright (c) 2014年 jiechu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCAlertView;

typedef void (^PositiveClickBlock)();
typedef void (^CancelClickBlcok)();
typedef void (^OtherClickBlcok)(NSUInteger buttonIndex);

@protocol JCAlertViewDelegate <NSObject>

- (void)alertView:(JCAlertView *)alertView didClickCancelButton:(UIButton *)button;
- (void)alertView:(JCAlertView *)alertView didClickPositiveButton:(UIButton *)button;
- (void)alertView:(JCAlertView *)alertView didClickOtherButtonAtIndex:(NSUInteger)buttonIndex;

@end

@interface JCAlertView : UIView

@property (nonatomic, getter=isDividerShow) BOOL dividerShow;

@property (weak, nonatomic) id<JCAlertViewDelegate> delegate;

@property (assign, nonatomic) PositiveClickBlock positiveBlock;
@property (assign, nonatomic) CancelClickBlcok cancelBlock;
@property (assign, nonatomic) OtherClickBlcok otherBlock;

@property (strong, nonatomic) UIView *customView;

- (instancetype)initWithPositiveButtonTitle:(NSString *)positiveTitle cancelButtonTitle:(NSString *)cancelTitle;
- (instancetype)initWithPositiveButtonTitle:(NSString *)positiveTitle cancelButtonTitle:(NSString *)cancelTitle positiveButtonClick:(PositiveClickBlock)positive cancelButtonClick:(CancelClickBlcok)cancel otherButtonClick:(OtherClickBlcok)other;

- (void)showInView:(UIView *)view;
- (void)hide;
- (void)addButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage;
@end
