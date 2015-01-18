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

#endif
