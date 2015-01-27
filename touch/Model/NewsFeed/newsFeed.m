//
//  newsFeed.m
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "newsFeed.h"
#import "User.h"

NSString * const NewsFeedClassName = @"NewsFeed";
NSString * const NewsFeedCreator = @"creator";
NSString * const NewsFeedEventType = @"event_type";
NSString * const NewsFeedContent = @"content";
NSString * const NewsFeedLikeUsers = @"likeUsers";
NSString * const NewsFeedComments = @"comments";

@implementation newsFeed

-(id)initForTest:(NSString *)s NT:(NewsType)i ID:(NSString *)nid
{
    newsFeed *feed = [[newsFeed alloc] init];
    feed.content = s;
    feed.eventType = i;
    feed.newsId = nid;
    feed.creator = [[User alloc] init];
    return feed;
}


+ (instancetype)newsFeedWithPFObject:(PFObject *)object {
    newsFeed *feed = [[newsFeed alloc] init];
    feed.content = [object valueForKey:NewsFeedContent];
    feed.eventType = [[object valueForKey:NewsFeedEventType] integerValue];
    feed.newsId = object.objectId;
    feed.creator = [User userWithPFObject:[object objectForKey:NewsFeedCreator]];
    return feed;
}

+ (PFObject *)getNewsFeedObject:(NSString *)newsId;
{
    PFQuery *query=[PFQuery queryWithClassName:NewsFeedClassName];
    PFObject *object = [query getObjectWithId:newsId];
    return object;
}

- (PFObject *)PFObjectValue {
    PFObject *object = [[PFObject alloc] initWithClassName:NewsFeedClassName];
    [object setObject:_content forKey:NewsFeedContent];
    [object setObject:[NSNumber numberWithInteger:_eventType] forKey:NewsFeedEventType];
    return object;
}



@end
