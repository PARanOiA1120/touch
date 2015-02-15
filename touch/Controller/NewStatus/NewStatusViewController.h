//
//  NewStatusViewController.h
//  touch
//
//  Created by Ariel Xin on 2/1/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newsFeed.h"
@class NewStatusViewController;
@protocol ActivityDelegate <NSObject>
-(void)didSend:(newsFeed *)nf;
@end

@interface NewStatusViewController : UIViewController
@property id<ActivityDelegate>delegate;
@end
