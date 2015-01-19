//
//  PhotoView.h
//  Meteor
//
//  Created by 常 屹 on 4/15/14.
//  Copyright (c) 2014 常 屹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoView;
@protocol PhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(PhotoView *)photoView;
- (void)photoViewSingleTap:(PhotoView *)photoView;
- (void)photoViewDidEndZoom:(PhotoView *)photoView;
@end

@class Photo;
@interface PhotoView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) Photo *photo;
@property (nonatomic, weak) id<PhotoViewDelegate> photoViewDelegate;
@end
