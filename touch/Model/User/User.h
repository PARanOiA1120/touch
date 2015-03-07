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
#import "PFDefine.h"

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
@property (strong, nonatomic) NSString* classlevel;

//get current user
+ (instancetype) currentUser;
//transfer from PFObject to PFUser
+ (instancetype) userWithPFObject:(PFObject *)object;
//return user based on user ID
+ (instancetype) userWithUserId:(NSString *)userId;
//Return PFObject based on user ID
- (PFObject *) getUserObject;
//check with database if the username/password pair is valid
- (void)logInWithUsernameInBackground: (NSString*)username password:(NSString*) password block:(PFBlock)block;
//database keep a record of user entered information
- (void)signUpInBackgroundWithBlock: (PFBlock)block;
- (BOOL)isLogined;
- (void)logOut;
//get access to other user's profile
+ (User *)getPFUserFromPFUser:(PFObject *)aUser;
//get full information for personal information
- (void) getFullInformation:(PFBlock)block;

@end
