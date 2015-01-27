//
//  PFDefine.h
//  touch
//
//  Created by Ariel Xin on 1/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#ifndef touch_PFDefine_h
#define touch_PFDefine_h

#import <parse/parse.h>


#define USERNAME_MIN_LENGTH 3
#define PASSWORD_MIN_LENGTH 6

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

typedef PFBooleanResultBlock BooleanResultBlock;
typedef PFArrayResultBlock ArrayResultBlock;
typedef PFDataResultBlock DictionaryResultBlcok;
typedef PFIdResultBlock IdResultBlcok;
typedef PFDataResultBlock DataResultBlock;

#define PFEVENT @"pfevent"
#define EVENT_TITLE @"event_title"
#define EVENT_TIME @"event_time"
#define LOCATION_NAME @"location_name"
#define EVENT_DESCRIPTION @"event_description"
#define BACKGROUND_IMAGE @"background_image"
#define LIKED_USERS @"liked_users"
#define JOINED_USERS @"joined_users"
#define APPLIED_USERS @"applied_users"
#define EVENT_OWNER @"event_owner"
#define EVENT_TYPE @"event_type"
#define SUBJECT_TYPE @"subject_type"

#endif
