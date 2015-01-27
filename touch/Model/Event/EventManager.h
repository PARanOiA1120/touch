//
//  EventManager.h
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "PFDefine.h"

FOUNDATION_EXPORT NSString * const FetchHotFunctionName;

typedef void (^PFBlock)(BOOL succeeded, NSError *error);

typedef NS_ENUM(NSUInteger, EventFetchType) {
    EventFetchTypeJoined = 0,
    EventFetchTypeCreatedByMe
};

@interface EventManager : NSObject

+ (instancetype)sharedManager;

//create new event
- (void)createEvent:(Event *)event InBackgroundWithBlock:(PFBooleanResultBlock)block;

- (void)postEvent:(Event *)event InBackgroundWithBlock:(PFBlock)block;

- (void)applyEvent:(Event *)event;

//get event detail
- (void)fetchDetailInfoOfEvent:(NSString *)eventId complete:(PFIdResultBlock)block;

//get event list
- (void)fetchEventWithType:(EventFetchType)type page:(NSInteger)page complete:(PFArrayResultBlock)blcok;

// join an event
- (void)joinEvent:(Event *)event complete:(PFBooleanResultBlock)block;

- (void)cancelJoinedEvent:(Event *)event complete:(PFBooleanResultBlock)block;

//get joined user list
- (void)fetchJoinedUsersOfEvent:(Event *)event complete:(PFArrayResultBlock)block;

//comment an event
- (void)addComment:(NSString *)comment onEvent:(Event *)event complete:(PFBooleanResultBlock)block;
- (void)fetchCommentsOfEvent:(Event *)event page:(NSUInteger)page pageSize:(NSUInteger)size complete:(PFArrayResultBlock)block;

// get data from cloud
- (void)cloud_fetchEventWithType:(EventFetchType)type page:(NSInteger)page complete:(PFDataResultBlock)block;
- (void)cloud_fetchEventDetail:(NSString *)eventId complete:(PFIdResultBlock)block;

@end
