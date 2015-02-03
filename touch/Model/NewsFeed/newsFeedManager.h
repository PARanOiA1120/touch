//
//  newsFeedManager.h
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFDefine.h"

@class newsFeed;
@class User;
@class Comment;
typedef void (^NewsFeedBlock)(NSArray *array, NSError *error);

@interface newsFeedManager : NSObject
+ (instancetype)sharedManager;
- (void)createNewsFeed:(newsFeed *)newsFeed InBackgroundWithBlock:(PFBooleanResultBlock)block;

- (void)getNewsFeedsInBackgroundwithParameters:(NSDictionary *)parameters WithBlock:(NewsFeedBlock)block;

- (void)likeNewsFeed:(NSString *)newsId ByUser:(User *)user InBackgroundWithBlock:(PFBooleanResultBlock)block;

- (void)unlikeNewsFeed:(NSString *)newsId ByUser:(User *)user InBackgroundWithBlock:(PFBooleanResultBlock)block;
@end
