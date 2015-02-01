//
//  ActivityTypeCell.h
//  touch
//
//  Created by Ariel Xin on 2/1/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTypeCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) UIImage *normalImage;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIColor *normalLabelColor;
@property (strong, nonatomic) UIColor *selectedLabelColor;
@end
