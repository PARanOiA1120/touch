//
//  PhotoBrowser.h
//  Meteor
//
//  Created by 常 屹 on 4/15/14.
//  Copyright (c) 2014 常 屹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoBrowser;
@protocol PhotoBrowserDelegate <NSObject>

- (void)photoBrowser:(PhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSInteger)index;

@end

@interface PhotoBrowser : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) id <PhotoBrowserDelegate> delegate;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSInteger currentPhotoIndex;

- (void)show;

@end
