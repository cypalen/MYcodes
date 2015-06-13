//
//  CYStudentCell.h
//  QQList
//
//  Created by lcy on 15/5/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYStudent.h"

@interface CYStudentCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *ageLabel;
@property (nonatomic,strong) UILabel *genderLabel;

-(void)refreshData:(CYStudent *)stu;

@end
