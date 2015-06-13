//
//  CYThreeImageCell.m
//  QQList
//
//  Created by lcy on 15/5/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYThreeImageCell.h"

@implementation CYThreeImageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
        
        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 0, 100, 100)];
        
        [self.contentView addSubview:self.imageView1];
        [self.contentView addSubview:self.imageView2];
        [self.contentView addSubview:self.imageView3];
    }
    
    return self;
}

-(void)refreshUI
{
    self.imageView1.image = [UIImage imageNamed:@"head.jpg"];
    self.imageView2.image = [UIImage imageNamed:@"head.jpg"];
    self.imageView3.image = [UIImage imageNamed:@"head.jpg"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
