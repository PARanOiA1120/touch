//
//  CustomAnimationView.h
//  touch
//
//  Created by jiapeiyao on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
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
