//
//  newsFeed.h
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@class Event;

FOUNDATION_EXPORT NSString * const NewsFeedClassName;
FOUNDATION_EXPORT NSString * const NewsFeedCreator;
FOUNDATION_EXPORT NSString * const NewsFeedEventType;
FOUNDATION_EXPORT NSString * const NewsFeedContent;
FOUNDATION_EXPORT NSString * const NewsFeedLikeUsers;
FOUNDATION_EXPORT NSString * const NewsFeedComments;

typedef NS_OPTIONS(NSInteger, NewsType) {
    NewsTypeOnlyText      = 0,
    NewsTypeJoinEvent     = 1,
    NewsTypeShareEvent    = 2,
    NewsTypeCreatedEvent  = 3
};

@interface newsFeed : NSObject

@property (copy, nonatomic) NSString *newsId;
@property (strong, nonatomic) User *creator;
@property (nonatomic) NewsType eventType;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *createTime;
@property (strong ,nonatomic) CLLocation *location;

@property (strong, nonatomic) NSDictionary *eventDic;
@property (assign, nonatomic) BOOL hasBeenPraised;
@property (strong, nonatomic) NSArray *likeUsers;
@property (assign, nonatomic) NSInteger likeUserCount;
@property (strong, nonatomic) NSArray *comments;
@property (assign, nonatomic) NSInteger commentCount;
@property (strong ,nonatomic) NSArray *taggedUsers;

-(id)initForTest:(NSString *)s NT:(NewsType)i ID:(NSString *)nid;

+ (instancetype)newsFeedWithPFObject:(PFObject *)object;

+ (PFObject *)getNewsFeedObject:(NSString *)newsId;

- (PFObject *)AVObjectValue;

@end
