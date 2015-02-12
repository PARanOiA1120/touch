//
//  BlackCell.m
//  touch
//
//  Created by CharlesYJP on 2/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import "BlackCell.h"

@implementation BlackCell

- (void)awakeFromNib {
    // Initialization code
    _headButton.layer.masksToBounds = YES;
    _headButton.layer.cornerRadius = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
