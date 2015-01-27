//
//  Event.m
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "Event.h"
#import "User.h"

#define SECONDS_PER_MINUTE      60
#define SECONDS_PER_HOUR        3600
#define SECONDS_HALF_DAY        43200
#define SECONDS_PER_DAY         86400

NSString * const className = @"event";
NSString * const title = @"event_title";
NSString * const startTime = @"event_time";
NSString * const subject = @"subject_type";
NSString * const background = @"background_image";
NSString * const location = @"location_name";
NSString * const type = @"event_type";
NSString * const description = @"event_description";
NSString * const creator = @"event_owner";
NSString * const likedUsers = @"liked_users";
NSString * const joinedUsers = @"joined_users";
NSString * const appliedUsers = @"applied_users";
NSString * const comments = @"comments";

@implementation Event

- (NSString *)timeText {
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:_eventTime];
    if (duration < SECONDS_PER_MINUTE) {
        return NSLocalizedString(@"time just now", @"just now");
    } else if (duration < SECONDS_PER_HOUR) {
        NSString *format = NSLocalizedString(@"time minute ago", @"minutes ago");
        return [NSString stringWithFormat:format, (long)(duration / SECONDS_PER_MINUTE)];
    } else if (duration < SECONDS_PER_DAY) {
        NSString *format = NSLocalizedString(@"time hour ago", @"hour ago");
        return [NSString stringWithFormat:format, (long)(duration / SECONDS_PER_HOUR)];
    } else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:NSLocalizedString(@"time format without year", @"dateformat")];
        return [format stringFromDate:_eventTime];
    }
}

- (NSString *)typeText {
    NSString *title = @"";
    switch (_subjectType) {
        case studyGroup:
            title = NSLocalizedString(@"event title study group", nil);
            break;
        case reviewSession:
            title = NSLocalizedString(@"event title review session", nil);
            break;
        case partnerRecruiting:
            title = NSLocalizedString(@"event title partner recruiting", nil);
            break;
        case infoSession:
            title = NSLocalizedString(@"event title info session", nil);
            break;
        case other:
            title = NSLocalizedString(@"event title other", nil);
            break;
        default:
            break;
    }
    NSString *format = NSLocalizedString(@"event type format", nil);
    return [NSString stringWithFormat:format, title];
}

- (PFObject *)PFObjectValue {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
    [newDict setObject:_title forKey:EVENT_TITLE];
    [newDict setObject:_eventTime forKey:EVENT_TIME];
    [newDict setObject:_locationName forKey:LOCATION_NAME];
    [newDict setObject:_eventDescription forKey:EVENT_DESCRIPTION];
    [newDict setObject:_background forKey:BACKGROUND_IMAGE];
    if (_likedUsers) {
        [newDict setObject:_likedUsers forKey:LIKED_USERS];
    }
    if (_joinedUsers) {
        [newDict setObject:_joinedUsers forKey:JOINED_USERS];
    }
    if (_needApplication)
    {
        [newDict setObject:_appliedUsers forKey:APPLIED_USERS];
    }
    if (_owner) {
        [newDict setObject:_owner forKey:EVENT_OWNER];
    }
    [newDict setObject:[NSNumber numberWithInt:_type] forKey:type];
    PFObject *object = [PFObject objectWithClassName:className dictionary:newDict];
    [object relationForKey:likedUsers];
    if (_eventId) {
        object.objectId = _eventId;
    }
    return object;
}

+ (instancetype)eventWithPFObject:(PFObject *)object {
    Event *event = [[Event alloc] init];
    event.eventId = object.objectId;
    event.title = [object objectForKey:title];
    event.eventTime = [object objectForKey:startTime];
    event.locationName = [object objectForKey:location];
    event.eventDescription = [object objectForKey:description];
    event.backgroundFile = [object objectForKey:background];
    event.owner = [object objectForKey:creator];
    event.background = [object objectForKey:background];
    event.likedUsers = [object objectForKey:LIKED_USERS];
    event.joinedUsers = [object objectForKey:JOINED_USERS];
    return event;
}

+ (instancetype)eventWithDictionary:(NSDictionary *)dic {
    Event *event = [[Event alloc] init];
    event.eventId = [dic objectForKey:@"objectId"];
    event.title = [dic objectForKey:@"event_title"];
    event.eventTime = [dic objectForKey:@"event_time"];
    event.eventDescription = [dic objectForKey:@"event_description"];
    event.locationName = [dic objectForKey:@"location_name"];
    event.type = [[dic objectForKey:@"event_type"] integerValue];
    event.likedByMe = [[dic objectForKey:@"liked_by_me"] boolValue];
    event.likeUserCount = [[dic objectForKey:@"like_user_count"] integerValue];
    event.commentUserCount = [[dic objectForKey:@"comment_count"] integerValue];
    event.joinUserCount = [[dic objectForKey:@"join_user_count"] integerValue];
    event.isCreator = [[dic objectForKey:@"is_creator"] boolValue];
    event.hasJoined = [[dic objectForKey:@"has_joined"] boolValue];
    if ([[dic objectForKey:@"like_users"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        for (NSDictionary *item in [dic objectForKey:@"like_users"]) {
            User *user = [[User alloc] init];
            user.recordID = [item objectForKey:@"userId"];
            user.username = [item objectForKey:@"username"];
            [users addObject:user];
        }
        event.likedUsers = users;
    }
    if ([[dic objectForKey:@"join_users"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        for (NSDictionary *item in [dic objectForKey:@"join_users"]) {
            User *user = [[User alloc] init];
            user.recordID = [item objectForKey:@"userId"];
            user.username = [item objectForKey:@"username"];
            [users addObject:user];
        }
        event.joinedUsers = users;
    }

    event.eventTime = [dic objectForKey:@"event_time"];
    if ([[dic objectForKey:@"event_owner"] isKindOfClass:[NSDictionary class]]) {
        User *user = [[User alloc] init];
        user.username = dic[@"event_owner"][@"username"];
        user.recordID = dic[@"event_owner"][@"userId"];
        event.creator = user;
    }
    return event;
}


@end
