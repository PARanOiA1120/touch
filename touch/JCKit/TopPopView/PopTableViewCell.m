//
//  PopTableViewCell.m
//  jiechu
//
//  Created by jianxd on 15/1/12.
//  Copyright (c) 2015年 jiechu. All rights reserved.
//

#import "PopTableViewCell.h"
#import "CommonDefine.h"
#import "TouchDefine.h"

@interface PopTableViewCell ()
@property (strong, nonatomic) UIView *backView;
@end

@implementation PopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENWIDTH, 50.0)];
    [self.contentView addSubview:backView];
    self.backView = backView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 12.0, 26.0, 26.0)];
    [self.contentView addSubview:imageView];
    self.iconImageView = imageView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 15.0, SCREENWIDTH - 80.0, 20.0)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGBCOLOR(184.0, 150.0, 101.0);
    label.font = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:label];
    self.nameLabel = label;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
//        _backView.backgroundColor = RGBACOLOR(184.0, 150.0, 101.0, 0.5);
        _backView.backgroundColor = [UIColor redColor];
    } else {
        _backView.backgroundColor = RGBACOLOR(184.0, 150.0, 101.0, 0.8);
    }
    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 50.0;
}

@end
