//
//  GalleryViewController.h
//  touch
//
//  Created by zhu on 1/26/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, GalleryFromType) {
    GalleryFromTypeDefault = 0,
    GalleryFromTypeHome = 1,
    GalleryFromTypeCreateActivity = 2
};

@class GalleryViewController;
@protocol GalleryControllerDelegate <NSObject>

@optional
- (void)galleryController:(GalleryViewController *)controller didChooseImages:(NSArray *)images forIndex:(NSArray *)list;
- (void)galleryController:(GalleryViewController *)controller shouldChangeToActivityCreationControllerWithImages:(NSArray *)images;
@end

@interface GalleryViewController : UIViewController
@property (weak, nonatomic) id<GalleryControllerDelegate> delegate;
@property (nonatomic) GalleryFromType fromType;
@property (nonatomic) NSUInteger photoCountLimit;
- (id)initWithSelectedImages:(NSArray *)list;
- (id)initWithImages:(NSArray *)images;
@end
