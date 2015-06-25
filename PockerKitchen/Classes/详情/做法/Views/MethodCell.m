//
//  MethodCell.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/17.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "MethodCell.h"

@implementation MethodCell

- (void)awakeFromNib {
    // Initialization code
    //这里可以做cell的初始化操作
    _titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
