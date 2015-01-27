//
//  CustomAnimationView.m
//  AnimationDemo
//
//  Created by xuxingdu on 14/10/28.
//  Copyright (c) 2014年 AI. All rights reserved.
//

#import "CustomAnimationView.h"
#import "CustomItem.h"
#import "VBFPopFlatButton.h"
#import "CommonDefine.h"
#import <POP.h>

#define ItemImages @[@"pop_activity.png",@"pop_video.png",@"pop_photo.png",@"pop_state.png",@"pop_sign_in.png"]
//此处设置点，x 和 y 的值均采用相对于屏幕的宽和高 单位 1 来表示。实际大小即 x *宽  或 y * 高
#define ItemEndPoints @[@{@"x":@"0.531",@"y":@"0.176"},@{@"x":@"0.375",@"y":@"0.387"},@{@"x":@"0.656",@"y":@"0.528"},@{@"x":@"0.281",@"y":@"0.598"},@{@"x":@"0.531",@"y":@"0.739"}]

@implementation CustomAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.dismissBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake((SCREENWIDTH - 57)/2, SCREENHEIGHT - 49 + 4, 57, 40) buttonType:buttonCloseType buttonStyle:buttonPlainStyle animateToInitialState:NO];
        self.dismissBtn.backgroundColor = [UIColor colorWithRed:235/255.0f green:74/255.0f blue:56/255.0f alpha:1.0];
        NSLog(@"%@",NSStringFromCGRect(self.dismissBtn.frame));
        [self.dismissBtn addTarget:self action:@selector(dismissBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dismissBtn];
        
        self.buttonItems = [self configButtonItems];
        
    }
    return self;
}


- (NSArray *)configButtonItems
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSMutableArray *buttonItems = [NSMutableArray array];
    for (int i = 0; i < ItemFuncion.count; i ++) {
        CustomItem *item = [[CustomItem alloc]initWithImageName:ItemImages[i]];
        item.endPoint = CGPointMake([ItemEndPoints[i][@"x"] floatValue]*screenWidth,[ItemEndPoints[i][@"y"] floatValue]*screenHeight);
        item.function = i;
        [buttonItems addObject:item];
    }
    return buttonItems;
}

// 初始化 items
- (void)setButtonItems:(NSArray *)buttonItems {
    _buttonItems = buttonItems;
    for (int i = 0; i < self.buttonItems.count; i++) {
        CustomItem * item = (CustomItem *)self.buttonItems[i];
        item.startPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height + item.frame.size.height/2);
        [item addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        item.center = item.startPoint;
        item.alpha = 0.0f;
        [self addSubview:item];
    }
}

//动画执行前 对items 进行布局
- (void)layoutItems
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CustomItem class]]) {
            CustomItem * item = (CustomItem *)view;
            item.center = item.startPoint;
            item.alpha = 0.0f;
        }
    }
    self.dismissBtn.alpha = 1.0f;
//    [self layoutSubviews];
}

//执行动画
/*
- (void)beginAnimations
{
    for (UIView *view in self.subviews){
        if ([view isKindOfClass:[CustomItem class]]) {
            
            CustomItem *item = (CustomItem *)view;
            CGPoint startPoint = item.startPoint;
            CGPoint endPoint = item.endPoint;
            CGFloat offsetY = kCustomAnimationViewOffset * fabs(startPoint.y - endPoint.y)/(sqrt(pow((startPoint.x - endPoint.x), 2)+pow((startPoint.y - endPoint.y), 2)));
            CGFloat offsetX = kCustomAnimationViewOffset * (endPoint.x - startPoint.x)/(sqrt(pow((startPoint.x - endPoint.x), 2)+pow((startPoint.y - endPoint.y), 2)));
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                item.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
            }];
            [UIView animateWithDuration:1.0f delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut animations:^{
                item.center = CGPointMake(item.endPoint.x, item.endPoint.y);
            } completion:^(BOOL finished) {
                item.center = CGPointMake(item.endPoint.x, item.endPoint.y);
                [UIView animateWithDuration:3.0f delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut animations:^{
                    item.center = CGPointMake(item.endPoint.x - offsetX, item.endPoint.y + offsetY);
                } completion:^(BOOL finished) {
                    item.center = CGPointMake(item.endPoint.x - offsetX, item.endPoint.y + offsetY);
                }];
            }];

        }
    }
}
 */
//执行动画
- (void)beginAnimations
{
    for (UIView *view in self.subviews){
        if ([view isKindOfClass:[CustomItem class]]) {
            
            CustomItem *item = (CustomItem *)view;
            CGPoint startPoint = item.startPoint;
            CGPoint endPoint = item.endPoint;
            CGFloat offsetY = kCustomAnimationViewOffset * fabs(startPoint.y - endPoint.y)/(sqrt(pow((startPoint.x - endPoint.x), 2)+pow((startPoint.y - endPoint.y), 2)));
            CGFloat offsetX = kCustomAnimationViewOffset * (endPoint.x - startPoint.x)/(sqrt(pow((startPoint.x - endPoint.x), 2)+pow((startPoint.y - endPoint.y), 2)));
            
            POPBasicAnimation *theAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            theAnimation.beginTime = 0.0f;
            theAnimation.duration= 0.5f;
            theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
            theAnimation.toValue=[NSNumber numberWithFloat:1.0];
            
            POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation1.toValue = [NSValue valueWithCGPoint:item.endPoint];
            animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation1.beginTime = 0.0f;
            animation1.duration = 0.5f;
            [animation1 setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
                POPBasicAnimation *animation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                animation2.toValue = [NSValue valueWithCGPoint:CGPointMake(item.endPoint.x - offsetX, item.endPoint.y + offsetY)];
                animation2.beginTime = 0.0f;
                animation2.duration = 3.5f;
                animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                [item pop_addAnimation:animation2 forKey:@"animation2"];
            }];
            [item pop_addAnimation:animation1 forKey:@"animation1"];
            [item pop_addAnimation:theAnimation forKey:@"theAnimation"];
        }
    }
}

- (void)dismissBtnPressed:(UIButton *)button
{
    NSLog(@"dismiss this view");
    [self layoutItems];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissCustomAnimationView)]) {
        [self.delegate dismissCustomAnimationView];
    }
}


- (void)itemPressed:(CustomItem *)item
{
    NSLog(@"item %@ is been pressed",item.currentTitle);
    [self layoutItems];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissCustomAnimationView)]) {
        [self.delegate itemClicked:item];
    }
}

@end
