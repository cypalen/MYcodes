//
//  CYThreeImageCell.h
//  QQList
//
//  Created by lcy on 15/5/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYThreeImageCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imageView1;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageView3;

-(void)refreshUI;
@end
