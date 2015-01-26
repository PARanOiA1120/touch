//
//  PopTableViewCell.h
//  jiechu
//
//  Created by jianxd on 15/1/12.
//  Copyright (c) 2015年 jiechu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel;

+ (CGFloat)cellHeight;
@end
