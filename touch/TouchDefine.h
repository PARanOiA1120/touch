//
//  TouchDefine.h
//  touch
//
//  Created by xinglunxu on 1/24/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#ifndef jiechu_JCDefine_h
#define jiechu_JCDefine_h




//#define AVOSAppID @"zw7ddgy3iiept1p2g12nyo4162vwb5vnv8lfhbpey8ed8ezz"
//#define AVOSAppKey @"7ecftfi1lfx8kssoau4mz0kmytgfnqkq56kpeolh9th9yybd"

#define AVOSAppID @"ugoqlskezzmiu2seo1ri07x64czw9qpcex9392r0gm0s63f8"
#define AVOSAppKey @"tznsrgtviw0kwzf51wdov9zy5s3na5a675w02o35fuo9auuc"

// 百度地图key
#define BMapKey @"jAh5imhaWBGnIF1mp1lMY1RH"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//user related

#define USERNAME_MIN_LENGTH 3
#define PASSWORD_MIN_LENGTH 6

//event

#define JCEVENT @"jcevent"
#define EVENT_TITLE @"event_title"
#define BACKGROUND_IMAGE @"background_image"
#define EVENT_TIME @"event_time"
#define LOCATION_NAME @"location_name"
#define EVENT_SCALE @"event_scale"
#define PAYMENT_TYPE @"payment_type"
#define STORE_INTRO @"store_intro"
#define EVENT_DISC @"event_disc"
#define PHOTO_WALL_RELATION @"photo_wall_relation"
#define GEO_POINT @"geo_point"
#define IS_FINISH @"is_finish"
#define IS_DEFAULT_IMAGE @"is_default_image"
#define DEFAULT_IMAGE_NAME @"default_image_name"
#define LIKED_USERS @"liked_users"
#define STARRED_USERS @"starred_users"
#define JOINED_USERS @"joined_users"
#define APPLIED_USERS @"applied_users"
#define INVITED_USERS @"invited_users"
#define EVENT_OWNER @"event_owner"
#define PRIVACY @"event_privacy"
#define EVENT_TYPE @"event_type"
#define ORIGINAL_MAX_WIDTH 640.0f

#define NET_DOMAIN @"jc_net"

//typedef AVBooleanResultBlock JCBooleanResultBlock;
//typedef AVArrayResultBlock JCArrayResultBlock;
//typedef AVDictionaryResultBlock JCDictionaryResultBlcok;
//typedef AVIdResultBlock JCIdResultBlcok;
//typedef AVDataResultBlock JCDataResultBlock;
#endif