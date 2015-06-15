//
//  CYBaseViewController.h
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYConst.h"

@interface CYBaseViewController : UIViewController

@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic,strong) NSMutableArray *dataArray;

//更新cell的内容  子类自己调用  父类只存放 所有子类共同的设置代码
-(void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//设置tabBar的内容
-(void)setTabBarItemTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)seclectedImageName;

//设置NavigationBar的内容
//ITEM_TYPE 用来区分左右按钮
//action 为按钮提供事件方法 ---> 如果子类中实现不同的点击事件 需要子类中自己实现
-(void)setNavigationBarTitle:(NSString *)title imageName:(NSString *)imageName pos:(ITEM_TYPE)pos action:(SEL)action;

//左边按钮 提供的方法
-(void)leftBtnClick;
//右边按钮提供的方法
-(void)rightBtnClick;

//下载方法
-(void)downLoadWithURL:(NSString *)urlStr;
@end
