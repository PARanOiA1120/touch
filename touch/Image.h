//
//  Image.h
//  touch
//
//  Created by Ariel Xin on 1/17/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <Parse/Parse.h>

@interface Image : PFObject <PFSubclassing>

@property (strong, nonatomic) PFUser *creator;

@property (copy, nonatomic) NSString *caption;

@property (strong, nonatomic) PFFile *rawImage;

@end
