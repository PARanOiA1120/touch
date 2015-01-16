//
//  User.h
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef void (^PFBlock)(BOOL succeeded, NSError *error);
typedef void (^PercentBlock)(NSInteger percent);
typedef void (^ImageBlock)(UIImage *image, NSError *error);
typedef void (^PFUserBlock)(NSArray *userArray,NSError *error);

@interface User : NSObject

//signup info
@property (strong, nonatomic) NSString* recordID;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* major;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSString* birthday;

//other info
@property (strong, nonatomic) UIImage* squareImage;
@property (strong, nonatomic) UIImage* largeImage;
@property (strong, nonatomic) NSString* school;
@property (strong, nonatomic) NSString* workPlace;
@property (strong, nonatomic) NSString* job;

//pic URL
@property (copy, nonatomic) NSString *thumbPath;
@property (copy, nonatomic) NSString *avatarPath;

+ (instancetype) currentUser;

//transfer from PFObject to PFUser
+ (instancetype) userWithAVObject:(PFObject *)object;

+ (instancetype) userWithUserId:(NSString *)userId;

- (PFObject *) getUserObject;

- (void) logInWithUsernameInBackground: (NSString*)username password:(NSString*) password block:(PFBlock)block;

- (void) signUpInBackgroundWithBlock: (PFBlock)block percentDone:(PercentBlock)percent squrePercent:(PercentBlock)squarePercent;

- (void)getSmallUserAvatarWithUserID:(NSString *)userID andWidth:(int)width andHeight:(int)height andBlock:(ImageBlock)block;

- (void)getNameAndUserAvatar:(PFBlock)block;


- (void)updateUserInfo: (PFBlock)block percentDone:(PercentBlock)percent squarePercent:(PercentBlock)squarePercent;

- (void)updateUserInfoWithoutImage:(PFBlock)block ;

- (void) getFullInformation:(PFBlock)block;

- (void)getTextInformation:(PFBlock)block;

- (BOOL) isLogined;

- (void) logOut;

+ (NSArray *)getJCUserArrayFromAVUserArray:(NSArray *)aUserArray;

@end
