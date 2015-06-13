//
//  CYStudentCell.m
//  QQList
//
//  Created by lcy on 15/5/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYStudentCell.h"

@implementation CYStudentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        
        [self.contentView addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 100, 30)];
        // 所有cell的子视图  都要加到 self.contentView
        [self.contentView addSubview:self.nameLabel];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, 100, 30)];
        
        //self.ageLabel.textAlignment = NSTextAlignmentCenter;
    
        [self.contentView addSubview:self.ageLabel];
        
        self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 65, 100, 30)];
        //self.genderLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.genderLabel];
    }
    return self;
}

-(void)refreshData:(CYStudent *)stu
{
    self.nameLabel.text = stu.name;
    self.ageLabel.text = stu.age;
    self.genderLabel.text = stu.gender;
    self.headImageView.image = [UIImage imageNamed:stu.headImage];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
