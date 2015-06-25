//
//  MaterialViewController.h
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialViewController : UIViewController
//接收原料
@property (nonatomic,copy)NSString *materialString;
//接收调料
@property (nonatomic,copy)NSString *flavouringString;
@property (nonatomic,copy)NSString *foodID;
@end
