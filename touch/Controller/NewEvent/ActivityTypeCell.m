//
//  ActivityTypeCell.m
//  touch
//
//  Created by Ariel Xin on 2/1/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "ActivityTypeCell.h"

@implementation ActivityTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _typeImageView.image = _selectedImage;
        _nameLabel.textColor = _selectedLabelColor;
    } else {
        _typeImageView.image = _normalImage;
        _nameLabel.textColor = _normalLabelColor != nil ? _normalLabelColor  : [UIColor blackColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        _typeImageView.image = _selectedImage;
        _nameLabel.textColor = _selectedLabelColor;
    } else {
        _typeImageView.image = _normalImage;
        _nameLabel.textColor = _normalLabelColor != nil ? _normalLabelColor  : [UIColor blackColor];
    }
}

@end
