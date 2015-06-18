//
//  LargeCell.h
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/18.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *littleCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong)NSArray *dataArray;

//接收一个bolck
@property (nonatomic,copy)void (^callBack)(NSDictionary *dic);
@end
