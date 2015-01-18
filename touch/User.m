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
           /* PFFile *imageFile=[user objectForKey:@"squareimage"];
            [imageFile getThumbnail:YES width:length*2 height:length*2 withBlock:^(UIImage *smallimage, NSError *error) {
                if (smallimage) {
                    self.squareImage = smallimage;
                    NSData *squareData = UIImagePNGRepresentation(self.squareImage);
                    [[NSUserDefaults standardUserDefaults] setObject:squareData forKey:@"IconCache"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ICON_CACHED"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }];*/
            block(YES,error);
        } else {
            block(NO,error);
        }
    }];
}

- (void)signUpInBackgroundWithBlock: (PFBlock)block percentDone:(PercentBlock)percent squrePercent:(PercentBlock)squarePercent;
{
    PFUser * user = [PFUser user];
    user.username = self.username;
    user.password =  self.password;

    [user setObject:self.major forKey:@"major"];
    [user setObject:self.gender forKey:@"gender"];
    [user setObject:self.classlevel forKey:@"classlevel"];
    
    /*
    [ProgressHUD show:@"Uploading portrait" Interaction:NO];
    NSData *imageData=UIImagePNGRepresentation(self.largeImage);
    PFFile *imageFile=[PFFile fileWithData:imageData];

    NSData *squareData = UIImagePNGRepresentation(self.squareImage);
    PFFile *squareFile = [PFFile fileWithData:squareData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeess, NSError *error) {
        if (succeess)
        {
            [ProgressHUD show:@"Uploading small portrait" Interaction:NO];
            [squareFile saveInBackgroundWithBlock:^(BOOL succes, NSError *error) {

                [ProgressHUD show:@"Finishing signup" Interaction:NO];
                [user setObject:imageFile forKey:@"largeimage"];
                [user setObject:squareFile forKey:@"squareimage"];
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        self.recordID=user.objectId;
                        block(YES,error);
                        
                    }
                    else
                    {
                        block(NO,error);
                    }
                }];
                
            } progressBlock:^(NSInteger percent) {
                squarePercent(percent);
            }];
        }
    } progressBlock:^(NSInteger percentDone) {
        percent(percentDone);
    }];*/
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
            /*PFFile *imageFile=[object objectForKey:@"squareimage"];
            PFFile *largeFile = [object objectForKey:@"largeimage"];
            [largeFile getThumbnail:YES width:SCREEN_WIDTH*2 height:SCREEN_HEIGHT*2 withBlock:^(UIImage *image, NSError *error) {
                if (image)
                {
                    self.largeImage = image;
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
                    [imageFile getThumbnail:YES width:length*2 height:length*2 withBlock:^(UIImage *smallimage, NSError *error) {
                        if (image) {
                            self.squareImage = smallimage;
                        }
                        block(YES,error);
                    }];
                }
                else
                {
                    block(NO,error);
                }
            }];
            
            fullInfoReturned=YES;
            
        } else {
            block(NO,error);
            NSLog(@"wrong");
        }*/
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

- (void)getSmallUserAvatarWithUserID:(NSString *)userID andWidth:(int)width andHeight:(int)height andBlock:(ImageBlock)block
{
   /* PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
        if (object)
        {
            PFFile *imageData = [object objectForKey:@"squareimage"];
            [imageData getThumbnail:YES width:width*2 height:height*2 withBlock:^(UIImage *thumbImage, NSError *error) {
                if (thumbImage)
                {
                    block(thumbImage, error);
                }
                else
                {
                    block(nil,error);
                }
            }];
        }
    }];*/
}

//获取少量用户信息
- (void)getNameAndUserAvatar:(PFBlock)block
{
    PFQuery *userQuery = [PFUser query];
    [userQuery getObjectInBackgroundWithId:self.recordID block:^(PFObject *object, NSError *error) {
        if (object)
        {
            self.username = [object objectForKey:@"username"];
           /* PFFile *thumbNailFile = [object objectForKey:@"squareimage"];
            [thumbNailFile getThumbnail:YES width:40*2 height:40*2 withBlock:^(UIImage *image, NSError *error) {
                if (image)
                {
                    self.squareImage = image;
                    block(YES,error);
                }
                else
                {
                    block(NO,error);
                }
            }];*/
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
    /*
    PFFile *oldLarge = [currentUser objectForKey:@"largeimage"];
    PFFile *oldSquare = [currentUser objectForKey:@"squareimage"];
    [ProgressHUD show:@"正在更新大头像" Interaction:NO];
    NSData *imageData=UIImagePNGRepresentation(self.largeImage);
    PFFile *imageFile=[PFFile fileWithData:imageData];
    NSData *squareData = UIImagePNGRepresentation(self.squareImage);
    PFFile *squareFile = [PFFile fileWithData:squareData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeess, NSError *error) {
        if (succeess)
        {
            [ProgressHUD show:@"正在更新小头像" Interaction:NO];
            [squareFile saveInBackgroundWithBlock:^(BOOL succes, NSError *error) {
                //[ProgressHUD showSuccess:@"小头像上传成功"];
                [ProgressHUD show:@"正在完成更新" Interaction:NO];
                [currentUser setObject:imageFile forKey:@"largeimage"];
                [currentUser setObject:squareFile forKey:@"squareimage"];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        self.recordID=currentUser.objectId;
                        [[NSUserDefaults standardUserDefaults] setObject:squareData forKey:@"IconCache"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ICON_CACHED"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [oldLarge deleteInBackgroundWithBlock:^(BOOL succ, NSError *error) {
                            if (succ)
                            {
                                [oldSquare deleteInBackgroundWithBlock:^(BOOL su, NSError *error) {
                                    if (su)
                                    {
                                        block(YES,error);
                                    }
                                    else
                                    {
                                        block(NO,error);
                                    }
                                }];
                            }
                            else
                            {
                                block(NO,error);
                            }
                        }];
                        
                        
                    }
                    else
                    {
                        block(NO,error);
                    }
                }];
                
            } progressBlock:^(NSInteger percent) {
                squarePercent(percent);
            }];
        }
    } progressBlock:^(NSInteger percentDone) {
        percent(percentDone);
    }];*/
    
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


//将AVUser 转换为 JCUser
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

//将存储 AVUser 的数组 转换为 存储JCUser Id 的数组
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

