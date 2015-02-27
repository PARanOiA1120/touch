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
#import "newsFeed.h"
#import "Image.h"

NSString * const FetchHotFunctionName = @"fetchHotEvent";

static const NSInteger DefaultPageSize = 10;

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
    [newDict setObject:event.title forKey:title];
    [newDict setObject:event.eventTime forKey:startTime];
    [newDict setObject:event.locationName forKey:location];
    [newDict setObject:event.eventDescription forKey:EVENT_DESCRIPTION];
//    if (event.background) {
//        [newDict setObject:event.background forKey:BACKGROUND_IMAGE];
//    }
    if (event.likedUsers) {
        [newDict setObject:event.likedUsers forKey:LIKED_USERS];
    }
    if (event.joinedUsers) {
        [newDict setObject:event.joinedUsers forKey:JOINED_USERS];
    }
    if (event.needApplication)
    {
        [newDict setObject:event.appliedUsers forKey:APPLIED_USERS];
    }
    if (event.owner) {
        [newDict setObject:event.owner forKey:EVENT_OWNER];
    }
    [newDict setObject:[NSNumber numberWithInt:event.subjectType] forKey:SUBJECT_TYPE];
    [newDict setObject:[NSNumber numberWithInt:event.type] forKey:EVENT_TYPE];
    return newDict;
}

- (void)createEvent:(Event *)event InBackgroundWithBlock:(PFBooleanResultBlock)block {
    if (event.owner == nil) {
        event.owner = [PFUser currentUser];
    }
    PFObject *eventObject = [PFObject objectWithClassName:PFEVENT dictionary:[self createDictionaryWithEvent:event]];
    if (event.background) {
        PFFile *imageFile = [PFFile fileWithData:UIImagePNGRepresentation(event.background)];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [eventObject setObject:imageFile forKey:BACKGROUND_IMAGE];
                [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    block(succeeded, error);
                }];
            } else {
                block(NO, error);
            }
        }];
    } else {
        [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            block(succeeded, error);
        }];
    }
}

- (void)postEvent:(Event *)event InBackgroundWithBlock:(PFBlock)block
{
    //initialize event object, set the basic attribute
    if (event.owner == nil) {
        event.owner = [PFUser currentUser];
    }
    PFObject *newEvent = [PFObject objectWithClassName:PFEVENT dictionary:[self createDictionaryWithEvent:event]];
    if (event.background){
        PFFile *backgroundImage = [PFFile fileWithData:UIImagePNGRepresentation(event.background)];
        [backgroundImage saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
            if (succeed)
            {
                [newEvent setObject:backgroundImage forKey:BACKGROUND_IMAGE];
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

- (void)fetchEventWithType:(EventFetchType)type page:(NSInteger)page complete:(PFArrayResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:PFEVENT];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"event_owner.name"];
    [query includeKey:@"event_owner.largeimage"];
    query.limit = DefaultPageSize;
    query.skip = page * DefaultPageSize;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *events = [NSMutableArray arrayWithCapacity:objects.count];
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"owner info : %@", [obj objectForKey:EVENT_OWNER]);
                [events addObject:[Event eventWithPFObject:obj]];
            }];
            block(events, error);
        } else {
            block(nil, error);
        }
    }];
}

- (void)joinEvent:(Event *)event complete:(PFBooleanResultBlock)block {
    PFObject *eventObject = [PFObject objectWithoutDataWithClassName:className objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFRelation *relation = [object relationforKey:joinedUsers];
        if (!error) {
            [relation addObject:[PFUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        }
    }];
}

- (void)cancelJoinedEvent:(Event *)event complete:(PFBooleanResultBlock)block {
    PFObject *eventObject = [PFObject objectWithoutDataWithClassName:className objectId:event.eventId];
    [eventObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFRelation *relation = [object relationforKey:joinedUsers];
            [relation removeObject:[PFUser currentUser]];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                block(succeeded, error);
            }];
        }
    }];
}

- (void)fetchJoinedUsersOfEvent:(Event *)event complete:(PFArrayResultBlock)block {
    PFObject *eventObject = [PFObject objectWithoutDataWithObjectId:event.eventId];
    PFQuery *query = [[eventObject relationforKey:joinedUsers] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}


- (void)cloud_fetchEventWithType:(EventFetchType)type page:(NSInteger)page complete:(PFDataResultBlock)block {
    NSDictionary *params = @{@"userId": [PFUser currentUser].objectId};
    [PFCloud callFunctionInBackground:@"fetchEvents" withParameters:params block:^(id object, NSError *error) {
        NSLog(@"cloud result %@", [object description]);
        NSArray *eventArray = object[@"events"];
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:eventArray.count];
        for (NSDictionary *item in eventArray) {
            Event *event = [Event eventWithDictionary:item];
            [events addObject:event];
        };
    }];
}

- (void)cloud_fetchEventDetail:(NSString *)eventId complete:(PFIdResultBlock)block {
    NSDictionary *params = @{@"event_id": eventId};
    if ([User currentUser].isLogined) {
        params = @{@"event_id": eventId,
                   @"user_id": [User currentUser].recordID};
    }
    [PFCloud callFunctionInBackground:@"fetchEventDetail" withParameters:params block:^(id object, NSError *error) {
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

- (void)cloud_shareEvent:(NSString *)event complete:(PFBooleanResultBlock)block {
    NSDictionary *params = @{@"event_id": event};
    if ([User currentUser].isLogined) {
        params = @{@"event_id": event,
                   @"user_id": [User currentUser].recordID};
    }
    [PFCloud callFunctionInBackground:@"shareEvent" withParameters:params block:^(id object, NSError *error) {
        
    }];
}

@end
