//
//  DetailViewController.h
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
//从首页传过来的数组
@property (nonatomic,strong)NSArray *dataArray;
//首页点击了那一页
@property (nonatomic,strong)NSNumber *index;
@end
