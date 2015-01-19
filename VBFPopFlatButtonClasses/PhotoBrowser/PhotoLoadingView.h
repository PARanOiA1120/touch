//
//  PhotoLoadingView.h
//  Meteor
//
//  Created by 常 屹 on 4/15/14.
//  Copyright (c) 2014 常 屹. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@interface PhotoLoadingView : UIView
@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;
@end
