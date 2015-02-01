//
//  EventManager.m
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "EventManager.h"
#import "Comment.h"
#import "User.h"
#import "NewsFeed.h"
#import "Image.h"

NSString * const kEventFetchHotFunctionName = @"fetchHotEvent";

static const NSInteger kDefaultPageSize = 10;

@implementation EventManager
+ (instancetype)sharedManager
{
    static EventManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (NSMutableDictionary *)createDictionaryWithEvent:(Event *)event
{
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:event.title forKey:kEventTitle];
    [newDict setObject:event.eventTime forKey:kEventEventTime];
    [newDict setObject:event.locationName forKey:kEventLocationName];
    [newDict setObject:[NSNumber numberWithInteger:event.scale] forKey:kEventScale];
    if (event.storeIntro) {
        [newDict setObject:event.storeIntro forKey:STORE_INTRO];
    }
    [newDict setObject:event.eventDisc forKey:EVENT_DISC];
    if (event.geoLocation) {
        [newDict setObject:event.geoLocation forKey:GEO_POINT];
    }
    if (event.background) {
        event.isDefaultImage = NO;
    } else {
        event.isDefaultImage = NO;
    }
    if (event.isDefaultImage)
    {
        [newDict setObject:event.defaultImageName forKey:DEFAULT_IMAGE_NAME];
    }
    if (event.likedUsers) {
        [newDict setObject:event.likedUsers forKey:LIKED_USERS];
    }
    if (event.starredUsers) {
        [newDict setObject:event.starredUsers forKey:STARRED_USERS];
    }
    if (event.joinedUsers) {
        [newDict setObject:event.joinedUsers forKey:JOINED_USERS];
    }
    if (event.invitedUsers) {
        [newDict setObject:event.invitedUsers forKey:INVITED_USERS];
    }
    if (event.needApplication)
    {
        [newDict setObject:event.appliedUsers forKey:APPLIED_USERS];
    }
    if (event.owner) {
        [newDict setObject:event.owner forKey:EVENT_OWNER];
    }
    [newDict setObject:[NSNumber numberWithInt:event.subjectType] forKey:EVENT_TYPE];
    [newDict setObject:[NSNumber numberWithBool:event.isFinished] forKey:IS_FINISH];
    [newDict setObject:[NSNumber numberWithBool:event.isDefaultImage] forKey:IS_DEFAULT_IMAGE];
    [newDict setObject:[NSNumber numberWithInt:event.privacy] forKey:kEventPrivacy];
    [newDict setObject:[NSNumber numberWithInt:event.payType] forKey:kEventPayType];
    [newDict setObject:[NSNumber numberWithInt:event.applyType] forKey:kEventApplyType];
    return newDict;
}

- (void)createEvent:(Event *)event InBackgroundWithBlock:(BooleanResultBlock)block {
    if (event.owner == nil) {
        event.owner = [AVUser currentUser];
    }
    AVObject *eventObject = [AVObject objectWithClassName:EVENT dictionary:[self createDictionaryWithEvent:event]];
    if (event.background) {
        AVFile *imageFile = [AVFile fileWithData:UIImagePNGRepresentation(event.background)];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [eventObject setObject:imageFile forKey:BACKGROUND_IMAGE];
                [self setEventPrivacy:event andObject:eventObject];
                [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    block(succeeded, error);
                }];
            } else {
                NSLog(@"update event image failed");
                block(NO, error);
            }
        }];
    } else {
        [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            block(succeeded, error);
        }];
    }
}

- (void)createEvent:(Event *)event withRelatedImages:(NSArray *)images InBackgroundWithBlock:(BooleanResultBlock)block {
    if (event.owner == nil) {
        event.owner = [AVUser currentUser];
    }
    if (event.owner == nil) {
        event.owner = [AVUser currentUser];
    }
    AVObject *eventObject = [AVObject objectWithClassName:EVENT dictionary:[self createDictionaryWithEvent:event]];
    if (event.background) {
        AVFile *imageFile = [AVFile fileWithData:UIImagePNGRepresentation(event.background)];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [eventObject setObject:imageFile forKey:BACKGROUND_IMAGE];
                [self setEventPrivacy:event andObject:eventObject];
                [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    block(succeeded, error);
                }];
            } else {
                NSLog(@"update event image failed");
                block(NO, error);
            }
        }];
    } else {
        [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            block(succeeded, error);
        }];
    }
    
}

- (void)postEvent:(Event *)event InBackgroundWithBlock:(Block)block
{
    //initialize event object, set the basic attribute
    if (event.owner == nil) {
        event.owner = [AVUser currentUser];
    }
    AVObject *newEvent = [AVObject objectWithClassName:EVENT dictionary:[self createDictionaryWithEvent:event]];
    if (event.background)
    {
        NSLog(@"has background iamge...");
        AVFile *backgroundImage = [AVFile fileWithData:UIImagePNGRepresentation(event.background)];
        [backgroundImage saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
            if (succeed)
            {
                [newEvent setObject:backgroundImage forKey:BACKGROUND_IMAGE];
                [self setEventPrivacy:event andObject:newEvent];
                [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
                    if (error1)
                    {
                        block(NO, nil);
                        NSLog(@"could not post event");
                    } else {
                        block(YES, nil);
                    }
                }];
            }
            else
            {
                block(NO, nil);
                NSLog(@"could not save file");
            }
        }];
    }
    else
    {
        [newEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
            if (error1)
            {
                NSLog(@"could not post event");
            }
        }];
    }
}

- (void)setEventPrivacy:(Event *)event andObject:(AVObject *)newEvent
{
    //privacy:
    //0 = invite only, not shown to public
    //1 = friends only, not shown to public
    //2 = follower only, not shown to public
    //3 = shown to public
    switch (event.privacy) {
        case 0:
        {
            [newEvent.ACL setPublicReadAccess:NO];
            [newEvent.ACL setPublicWriteAccess:NO];
            [newEvent.ACL setReadAccess:YES forUser:event.owner];
            /*for (AVUser *invited in event.invitedUsers)
             {
             [newEvent.ACL setReadAccess:YES forUser:invited];
             }*/
            [newEvent.ACL setWriteAccess:YES forUser:event.owner];
        }
            break;
        case 1:
        {
            [newEvent.ACL setPublicReadAccess:NO];
            [newEvent.ACL setPublicWriteAccess:NO];
            [newEvent.ACL setReadAccess:YES forUser:event.owner];
            [newEvent.ACL setWriteAccess:YES forUser:event.owner];
            //get the friends
        }
            break;
        case 2:
        {
            [newEvent.ACL setPublicReadAccess:NO];
            [newEvent.ACL setPublicWriteAccess:NO];
            [newEvent.ACL setReadAccess:YES forUser:event.owner];
            [newEvent.ACL setWriteAccess:YES forUser:event.owner];
            [event.owner getFollowees:^(NSArray *objects, NSError *error) {
                if (objects)
                {
                    for (NSObject *object in objects)
                    {
                        if ([object isKindOfClass:[AVUser class]])
                        {
                            [newEvent.ACL setReadAccess:YES forUser:(AVUser *)object];
                        }
                    }
                }
                else
                {
                    NSLog(@"cannot retrive followers");
                }
            }];
        }
            break;
        case 3:
        {
            [newEvent.ACL setPublicReadAccess:YES];
            [newEvent.ACL setPublicWriteAccess:NO];
            [newEvent.ACL setReadAccess:YES forUser:event.owner];
            [newEvent.ACL setWriteAccess:YES forUser:event.owner];
        }
            break;
            
        default:
            break;
    }
}

- (void)applyEvent:(Event *)event
{
    
}

// 申请参加活动
- (void)applyEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVQuery *query = [AVQuery queryWithClassName:kEventClassName];
    [query getObjectInBackgroundWithId:event.eventId block:^(AVObject *object, NSError *error) {
        if (!error) {
            // 查询成功
            AVRelation *relation = [object relationforKey:kEventAppliedUsers];
            AVRelation *joinRelation = [object relationforKey:kEventJoinedUsers];
            [relation addObject:[AVUser currentUser]];
            [joinRelation addObject:[AVUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        } else {
            // 查询失败
            block(NO, error);
        }
    }];
}

// 取消活动申请
- (void)cancelApplicationForEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *eventObject = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            AVRelation *relation = [object relationforKey:kEventAppliedUsers];
            [relation removeObject:[AVUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        } else {
            block(NO, error);
        }
    }];
}

// 收藏活动
- (void)starEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *eventObject = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            // 查询成功
            AVRelation *relation = [object relationforKey:kEventStarredUsers];
            [relation addObject:[AVUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        } else {
            // 查询失败
            block(NO, error);
        }
    }];
}

// 取消收藏活动
- (void)unstarEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *eventObject = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            // 查询成功
            AVRelation *relation = [object relationforKey:kEventStarredUsers];
            [relation removeObject:[AVUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        } else {
            // 查询失败
            block(NO, error);
        }
    }];
}

- (NSMutableArray *)filterEventWithPreference:(NSDictionary *)preference
{
    NSMutableArray *filteredEvents = [[NSMutableArray alloc] init];
    return filteredEvents;
}

- (void)fetchDetailInfoOfEvent:(NSString *)eventId complete:(IdResultBlcok)block {
    AVQuery *query = [AVQuery queryWithClassName:kEventClassName];
    [query getObjectInBackgroundWithId:eventId block:^(AVObject *object, NSError *error) {
        if (!error) {
            // 查询成功
            Event *event = [Event eventWithAVObject:object];
            AVQuery *imageQuery = [[object relationforKey:kEventRelatedImages] query];
            // 相关图片查询
            [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                event.relatedImages = objects;
                AVQuery *likedQuery = [[object relationforKey:kEventLikedUsers] query];
                likedQuery.limit = 10;
                // 喜欢的人查询
                [likedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    event.likedUsers = objects;
                    AVQuery *starredQuery = [[object relationforKey:kEventStarredUsers] query];
                    starredQuery.limit = 10;
                    // 收藏的人查询
                    [starredQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        event.starredUsers = objects;
                        AVQuery *joinedQuery = [[object relationforKey:kEventJoinedUsers] query];
                        joinedQuery.limit = 10;
                        // 参加的人查询
                        [joinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            event.joinedUsers = objects;
                            
                            AVQuery *commentQuery = [AVQuery queryWithClassName:kCommentClassName];
                            [commentQuery whereKey:kCommentPost equalTo:eventId];
                            commentQuery.limit = 10;
                            // 评论查询
                            [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                event.comments = objects;
                                block(event, error);
                            }];
                        }];
                    }];
                }];
            }];
        } else {
            // 查询失败
        }
    }];
}

- (void)fetchEventWithType:EventFetchType)type page:(NSInteger)page complete:(ArrayResultBlock)block {
    AVQuery *query = [AVQuery queryWithClassName:EVENT];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"event_owner.name"];
    [query includeKey:@"event_owner.largeimage"];
    query.limit = kDefaultPageSize;
    query.skip = page * kDefaultPageSize;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 获取成功
            NSMutableArray *events = [NSMutableArray arrayWithCapacity:objects.count];
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"owner info : %@", [obj objectForKey:EVENT_OWNER]);
                [events addObject:[Event eventWithAVObject:obj]];
            }];
            block(events, error);
        } else {
            // 获取失败
            block(nil, error);
        }
    }];
}

// 获取活动相关图片
- (void)fetchRelatedImagesOfEvent:(Event *)event complete:ArrayResultBlock)block {
    AVQuery *query = [[[event AVObjectValue] relationforKey:kEventRelatedImages] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

- (void)doLikeEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *eventObject = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVRelation *relation = [object relationforKey:kEventLikedUsers];
        if (!error) {
            [relation addObject:[AVUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        }
    }];
}

- (void)cancelLikeEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *eventObject = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            AVRelation *relation = [object relationforKey:kEventLikedUsers];
            [relation removeObject:[AVUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        }
    }];
}

- (void)fetchLikedUsersOfEvent:(Event *)event complete:(ArrayResultBlock)block {
    AVObject *eventObject = [AVObject objectWithoutDataWithObjectId:event.eventId];
    AVQuery *query = [[eventObject relationforKey:kEventLikedUsers] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

// 添加评论
- (void)addComment:(NSString *)comment onEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *object = [AVObject objectWithClassName:kCommentClassName];
    [object setObject:comment forKey:kCommentContent];
    [object setObject:[AVUser currentUser] forKey:kCommentCreator];
    [object setObject:event.eventId forKey:kCommentPost];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded, error);
        if (!error) {
            // 添加评论成功
            NSLog(@"添加评论成功");
        } else {
            // 添加评论时报
            NSLog(@"添加评论失败");
        }
    }];
}

// 获取分页评论列表
- (void)fetchCommentsOfEvent:(Event *)event page:(NSUInteger)page pageSize:(NSUInteger)size complete:(ArrayResultBlock)block {
    AVQuery *query = [AVQuery queryWithClassName:kCommentClassName];
    [query whereKey:kCommentPost equalTo:event.eventId];
    [query orderByDescending:@"createdAt"];
    query.limit = size;
    query.skip = page * size;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
        if (!error) {
            NSLog(@"获取评论列表成功");
        } else {
            NSLog(@"获取评论列表失败");
        }
    }];
}

- (void)shareEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVQuery *query = [AVQuery queryWithClassName:kEventClassName];
    [query getObjectInBackgroundWithId:event.eventId block:^(AVObject *object, NSError *error) {
        if (!error) {
            NSLog(@"event id : %@", event.eventId);
            AVObject *newsObject = [AVObject objectWithClassName:kNewsFeedClassName];
            [newsObject setObject:[AVUser currentUser] forKey:kNewsFeedCreator];
            [newsObject setObject:[NSNumber numberWithInteger:NewsTypeShareEvent] forKey:kNewsFeedEventType];
            [newsObject setObject:event.eventId forKey:@"related_event"];
            //            [newsObject setObject:object forKey:kNewsFeedRelateEvent];
            [newsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        } else {
            block(NO, error);
        }
    }];
    //    AVObject *eventObject = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    //    [eventObject fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
    //
    //    }];
}

- (void)updateRelatedImage:(UIImage *)image forEvent:(Event *)event complete:(BooleanResultBlock)block {
    AVObject *object = [AVObject objectWithoutDataWithClassName:kEventClassName objectId:event.eventId];
    [object fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            AVFile *file = [AVFile fileWithData:UIImagePNGRepresentation(image)];
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    Image *img = [[Image alloc] init];
                    img.rawImage = file;
                    [img saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        AVRelation *relation = [object relationforKey:kEventRelatedImages];
                        [relation addObject:img];
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            block(succeeded, error);
                        }];
                    }];
                }
            }];
        } else {
            
        }
    }];
}

- (void)cloud_fetchEventWithType:(JCEventFetchType)type page:(NSInteger)page complete:(DictionaryResultBlcok)block {
    NSDictionary *params = @{@"userId": [AVUser currentUser].objectId};
    [AVCloud callFunctionInBackground:@"fetchEvents" withParameters:params block:^(id object, NSError *error) {
        NSLog(@"cloud result %@", [object description]);
        NSArray *eventArray = object[@"events"];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:eventArray.count];
        for (NSDictionary *item in eventArray) {
            Event *event = [Event eventWithDictionary:item];
            [events addObject:event];
        }
        block(@{@"events": events}, error);
    }];
}

- (void)cloud_fetchEventDetail:(NSString *)eventId complete:(IdResultBlcok)block {
    NSDictionary *params = @{@"event_id": eventId};
    if ([User currentUser].isLogined) {
        params = @{@"event_id": eventId,
                   @"user_id": [User currentUser].recordID};
    }
    [AVCloud callFunctionInBackground:@"fetchEventDetail" withParameters:params block:^(id object, NSError *error) {
        NSLog(@"event detail : %@", [object description]);
        if (!error) {
            // 获取成功
            Event *event = [Event eventWithDictionary:object[@"event_detail"]];
            block(event, error);
        } else {
            block(nil, error);
        }
    }];
}

- (void)cloud_shareEvent:(NSString *)event complete:(BooleanResultBlock)block {
    NSDictionary *params = @{@"event_id": event};
    if ([User currentUser].isLogined) {
        params = @{@"event_id": event,
                   @"user_id": [User currentUser].recordID};
    }
    [AVCloud callFunctionInBackground:@"shareEvent" withParameters:params block:^(id object, NSError *error) {
        
    }];
}

@end
