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

+ (User *)currentUser {
    static User *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];});
    return instance;
}


+ (instancetype) userWithPFObject:(PFObject *)object
{
    User *user = [[User alloc] init];
    user.recordID = object.objectId;
    user.username=[object objectForKey:@"username"];
    user.gender= [object objectForKey:@"gender"];
    user.major= [object objectForKey:@"major"];
    user.classlevel = [object objectForKey:@"classlevel"];
    
    return user;
}

//根据 userid 返回对应的用户实例
+ (instancetype) userWithUserId:(NSString *)userId
{
    PFQuery *query=[PFUser query];
    PFObject *object = [query getObjectWithId:userId];
    return [User userWithPFObject:object];
}


//Return PFObject using based on user
- (PFObject *) getUserObject
{
    PFQuery *query=[PFUser query];
    PFObject *object = [query getObjectWithId:self.recordID];
    return object;
}

- (void) logInWithUsernameInBackground: (NSString*)username password:(NSString*) password block:(PFBlock)block {
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
        if (user) {
            self.recordID=user.objectId;
            self.username=user.username;
            self.password=user.password;
            
            CGFloat length = 0.0;
            if (IS_IPHONE_6P)
            {
                length = 90;
            }
            if (IS_IPHONE_6)
            {
                length = 80;
            }
            if (IS_IPHONE_5)
            {
                length = 75;
            }
            if (IS_IPHONE_4_OR_LESS)
            {
                length = 65;
            }
            block(YES,error);
        } else {
            block(NO,error);
        }
    }];
}

- (void)signUpInBackgroundWithBlock: (PFBlock)block
{
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

- (void) getFullInformation:(PFBlock)block {
    [ProgressHUD show:@"正在获取" Interaction:NO];
    PFQuery *query=[PFUser query];
    [query getObjectInBackgroundWithId:self.recordID block:^(PFObject *object, NSError *error) {
        if (!error) {
            self.recordID = object.objectId;
            self.username=[object objectForKey:@"userName"];
            self.gender = [object objectForKey:@"gender"];
            self.classlevel = [object objectForKey:@"classlevel"];
            self.major=[object objectForKey:@"major"];
        }
           }];
}

- (void)getTextInformation:(PFBlock)block
{
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:self.recordID block:^(PFObject *object, NSError *error) {
        if (object)
        {
            self.recordID = object.objectId;
            self.gender = [object objectForKey:@"gender"];
            self.classlevel = [object objectForKey:@"classlevel"];
            self.major=[object objectForKey:@"major"];
            block(YES,error);
        }
        else
        {
            block(NO,error);
        }
    }];
}


- (void)getNameAndUserAvatar:(PFBlock)block
{
    PFQuery *userQuery = [PFUser query];
    [userQuery getObjectInBackgroundWithId:self.recordID block:^(PFObject *object, NSError *error) {
        if (object)
        {
            self.username = [object objectForKey:@"username"];

        }
    }];
}

//更新用户的个人信息
- (void)updateUserInfo: (PFBlock)block percentDone:(PercentBlock)percent squarePercent:(PercentBlock)squarePercent
{
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:self.gender forKey:@"gender"];
    [currentUser setObject:self.major forKey:@"major"];
    [currentUser setObject:self.classlevel forKey:@"classlevel"];

    
}

- (void)updateUserInfoWithoutImage:(PFBlock)block
{
    [ProgressHUD show:@"Updating" Interaction:NO];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:self.gender forKey:@"gender"];
    [currentUser setObject:self.major forKey:@"major"];
    [currentUser setObject:self.classlevel forKey:@"classlevel"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [ProgressHUD showSuccess:@"Update successful！"];
            self.recordID = currentUser.objectId;
            block(YES,error);
        }
        else
        {
            block(NO,error);
        }
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



+ (User *)getPFUserFromPFUser:(PFObject *)aUser
{
    User *user = [[User alloc] init];
    user.recordID = aUser.objectId;
    user.username=[aUser objectForKey:@"username"];
    user.gender = [aUser objectForKey:@"gender"];
    user.classlevel = [aUser objectForKey:@"classlevel"];
    user.major=[aUser objectForKey:@"major"];
    return user;
}

+ (NSArray *)getPFUserIdArrayFromPFUserArray:(NSArray *)aUserArray
{
    NSMutableArray *jUserArray = [NSMutableArray arrayWithCapacity:aUserArray.count];
    if (aUserArray.count > 0) {
        for (PFObject *object in aUserArray) {
            if (![object isKindOfClass:[NSNull class]]) {
                [jUserArray addObject:object.objectId];
            }
        }
    }
    return jUserArray;
}


@end

