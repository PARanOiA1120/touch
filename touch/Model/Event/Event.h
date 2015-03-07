//
//  Event.h
//  touch
//
//  Created by Ariel Xin on 1/21/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class User;
FOUNDATION_EXPORT NSString * const className;
FOUNDATION_EXPORT NSString * const title;
FOUNDATION_EXPORT NSString * const startTime;
FOUNDATION_EXPORT NSString * const subject;
FOUNDATION_EXPORT NSString * const background;
FOUNDATION_EXPORT NSString * const location;
FOUNDATION_EXPORT NSString * const type;
FOUNDATION_EXPORT NSString * const description;
FOUNDATION_EXPORT NSString * const creator;
FOUNDATION_EXPORT NSString * const likedUsers;
FOUNDATION_EXPORT NSString * const joinedUsers;
FOUNDATION_EXPORT NSString * const appliedUsers;
FOUNDATION_EXPORT NSString * const comments;

typedef NS_OPTIONS(NSUInteger, subjectType) {
    studyGroup = 0,
    reviewSession = 1,
    partnerRecruiting = 2,
    infoSession = 3,
    other = 4
};


typedef NS_OPTIONS(NSUInteger, eventType) {
    rsvp  = 0,
    toPublic = 1
};

@interface Event : NSObject

//each event has a unique eventId in database
@property (strong, nonatomic) NSString *eventId;

@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) UIImage* background;
@property (strong, nonatomic) PFFile *backgroundFile;
@property (nonatomic) subjectType subjectType;
@property (strong,nonatomic) NSDate* eventTime;
@property (strong,nonatomic) NSString* locationName;
@property (nonatomic) eventType type;
@property (strong,nonatomic) NSString* eventDescription;

@property (strong,nonatomic) NSArray* likedUsers;
@property (strong,nonatomic) NSArray* joinedUsers;
@property (strong,nonatomic) NSArray* appliedUsers;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) PFUser *owner;
@property (strong, nonatomic) User *creator;
@property (nonatomic) BOOL needApplication;

@property (nonatomic) NSUInteger likeUserCount;
@property (nonatomic) NSUInteger commentUserCount;
@property (nonatomic) NSUInteger joinUserCount;


@property (nonatomic) BOOL likedByMe;
@property (nonatomic) BOOL isCreator;
@property (nonatomic) BOOL hasJoined;

@property (strong, nonatomic, readonly) NSString *titleTypeText;
@property (strong, nonatomic, readonly) NSString *timeText;
@property (strong, nonatomic, readonly) NSString *typeText;


- (PFObject *)PFObjectValue;

+ (instancetype)eventWithPFObject:(PFObject *)object;
+ (instancetype)eventWithDictionary:(NSDictionary *)dic;
+(PFObject *)getEventObject:(NSString *) newsId;

@end
