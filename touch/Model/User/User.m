//
//  User.m
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "User.h"
#import "ProgressHUD.h"
#import "CommonDefine.h"
#import "Image.h"

@implementation User

BOOL fullInfoReturned=NO;

//get current user
+ (User *)currentUser {
    static User *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];});
    return instance;
}

//transfer from PFObject to PFUser
+ (instancetype) userWithPFObject:(PFObject *)object{
    User *user = [[User alloc] init];
    user.recordID = object.objectId;
    user.username=[object objectForKey:@"username"];
    user.gender= [object objectForKey:@"gender"];
    user.major= [object objectForKey:@"major"];
    user.classlevel = [object objectForKey:@"classlevel"];
    return user;
}

//return user based on user ID
+ (instancetype) userWithUserId:(NSString *)userId{
    PFQuery *query=[PFUser query];
    PFObject *object = [query getObjectWithId:userId];
    return [User userWithPFObject:object];
}


//Return PFObject based on user ID
- (PFObject *) getUserObject{
    PFQuery *query=[PFUser query];
    PFObject *object = [query getObjectWithId:self.recordID];
    return object;
}

//check with database if the username/password pair is valid
- (void) logInWithUsernameInBackground: (NSString*)username password:(NSString*) password block:(PFBlock)block {
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
        if (user) {
            self.recordID=user.objectId;
            self.username=user.username;
            self.password=user.password;
            
            CGFloat length = 0.0;
            if (IS_IPHONE_6P){
                length = 90;
            }
            if (IS_IPHONE_6){
                length = 80;
            }
            if (IS_IPHONE_5){
                length = 75;
            }
            if (IS_IPHONE_4_OR_LESS){
                length = 65;
            }
            block(YES,error);
        } else {
            block(NO,error);
        }
    }];
}

//database keep a record of user entered information
- (void)signUpInBackgroundWithBlock: (PFBlock)block{
    PFUser * user = [PFUser user];
    user.username = self.username;
    user.password =  self.password;
    
    [user setObject:self.major forKey:@"major"];
    [user setObject:self.gender forKey:@"gender"];
    [user setObject:self.classlevel forKey:@"classlevel"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded,error);
    }];
    
}


- (BOOL) isLogined {
    PFUser * currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        self.recordID = currentUser.objectId;
        self.username=currentUser.username;
        self.gender = [currentUser objectForKey:@"gender"];
        self.major = [currentUser objectForKey:@"major"];
        self.classlevel = [currentUser objectForKey:@"classlevel"];
        return YES;
    } else {
        return NO;
    }
}

- (void) logOut {
    [PFUser logOut];
    fullInfoReturned=NO;
}

//get access to other user's profile
+ (User *)getPFUserFromPFUser:(PFObject *)aUser{
    User *user = [[User alloc] init];
    user.recordID = aUser.objectId;
    user.username=[aUser objectForKey:@"username"];
    user.gender = [aUser objectForKey:@"gender"];
    user.classlevel = [aUser objectForKey:@"classlevel"];
    user.major=[aUser objectForKey:@"major"];
    return user;
}

@end

