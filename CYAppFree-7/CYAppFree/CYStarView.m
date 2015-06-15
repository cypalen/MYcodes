//
//  CYStarView.m
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYStarView.h"

@implementation CYStarView
{
    UIImageView *backImageView;
    UIImageView *foreImageView;
}

//xib 加载view  ---->  initWithCoder  归档 
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backImageView.image = [UIImage imageNamed:@"StarsBackground"];
        [self addSubview:backImageView];
        
        foreImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        foreImageView.contentMode = UIViewContentModeLeft;
        foreImageView.clipsToBounds = YES;
        foreImageView.image = [UIImage imageNamed:@"StarsForeground"];
        [self addSubview:foreImageView];
    }
    return self;
}

//设置评分  改变imageView的frame的宽度
-(void)setStar:(CGFloat)star
{
    CGFloat s = star / 5.0f;
    CGRect tempFrame = backImageView.frame;
    tempFrame.size.width *= s;
    foreImageView.frame = tempFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
