//
//  FittingCell.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/17.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "FittingCell.h"

@implementation FittingCell

- (void)awakeFromNib {
    // Initialization code
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _describeLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
