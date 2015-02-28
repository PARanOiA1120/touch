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

- (void)createNewsFeed:(newsFeed *)newsFeed{
    PFObject *object = [newsFeed PFObjectValue];
    object[NewsFeedCreator] = [PFUser currentUser];
//    [object setObject:[User currentUser] forKey:NewsFeedCreator];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"createNewsFeed Error");
        }
        
    }];
}


- (NSMutableArray *)getNewsFeedsInBackground
{
    PFQuery *query = [PFQuery queryWithClassName:@"NewsFeed"];
    NSArray *array= [query findObjects];
    query = [PFQuery queryWithClassName:PFEVENT];
    NSArray *array2 = [query findObjects];
    array = [array arrayByAddingObjectsFromArray:array2];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for(int i=array.count-1; i>-1; i--)
    {
        newsFeed* nf = [[newsFeed alloc] init];
        PFObject *object = array[i];
        nf.creator = [User userWithPFObject:object[@"creator"]];
        nf.eventType = [object[@"event_type"] integerValue];
        if(object[BACKGROUND_IMAGE]!=nil)
        {
            nf.photo = object[BACKGROUND_IMAGE];
        }
        [returnArray addObject:nf];
        
        if(nf.eventType == 0)
        {
            nf.content = object[EVENT_DESCRIPTION];
            nf.creator = [User userWithPFObject:object[EVENT_OWNER]];
        }
        else
        {
            nf.content = object[@"content"];
            nf.creator = [User userWithPFObject:object[@"creator"]];
        }
        
    }
    return returnArray;
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
