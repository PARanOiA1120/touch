//
//  newsFeedManager.m
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "newsFeedManager.h"
#import "newsFeed.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ProgressHUD.h"
#import "Image.h"
#import "Comment.h"

@implementation newsFeedManager
+ (instancetype)sharedManager {
    static newsFeedManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)createNewsFeed:(newsFeed *)newsFeed InBackgroundWithBlock:(PFBooleanResultBlock)block {
    PFObject *object = [newsFeed PFObjectValue];
    [object setObject:[User currentUser] forKey:NewsFeedCreator];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            block(succeeded, error);
        }
    }];
}


- (void)getNewsFeedsInBackgroundwithParameters:(NSDictionary *)parameters WithBlock:(NewsFeedBlock)block
{

}

//点赞
- (void)likeNewsFeed:(NSString *)newsId ByUser:(PFUser *)user InBackgroundWithBlock:(PFBooleanResultBlock)block
{
    [ProgressHUD show:@"In progress" Interaction:NO];

}


- (void)unlikeNewsFeed:(NSString *)newsId ByUser:(User *)user InBackgroundWithBlock:(PFBooleanResultBlock)block
{
    [ProgressHUD show:@"In progress" Interaction:NO];
    PFObject *object = [newsFeed getNewsFeedObject:newsId];
    PFRelation *relation = [object relationforKey:NewsFeedLikeUsers];
    [relation removeObject:[user getUserObject]];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [ProgressHUD dismiss];
        block(succeeded, error);
    }];
}
@end
