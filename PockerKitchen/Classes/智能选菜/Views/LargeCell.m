//
//  LargeCell.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/18.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "LargeCell.h"
#import "LittleCell.h"
@implementation LargeCell
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LittleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LittleCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *name = dic[@"littleName"];
    NSString *imgPath = dic[@"imgPath"];
    
    cell.imgView.image = [UIImage imageNamed:imgPath];
    cell.titleLabel.text = name;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArray[indexPath.row];
    
    if (_callBack)
    {
        //每点击一个材料,就将它传回去
        _callBack(dic);
    }
}
@end
