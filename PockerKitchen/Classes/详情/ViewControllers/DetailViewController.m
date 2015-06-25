//
//  DetailViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "DetailViewController.h"
#import "MainCell.h"
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _currentPage;//记录当前页
}
@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tasteLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取到上面传过来的位置
    NSInteger index = _index.integerValue;
    
    //上面传过来的,就是当前页
    _currentPage = index;
    
    //让collectionView滚到相应位置
    [_detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    //加载页面,就开始更新菜名
    [self updateFoodInfo:_currentPage];
}

//刷新菜谱信息
- (void)updateFoodInfo:(NSInteger)index
{
    NSDictionary *dic = _dataArray[index];
    _chineseNameLabel.text = dic[@"name"];
    _englishNameLabel.text = dic[@"englishName"];
    _cookTimeLabel.text = dic[@"timeLength"];
    _tasteLabel.text = dic[@"taste"];
    _cookMethodLabel.text = dic[@"cookingMethod"];
    _effectLabel.text = dic[@"effect"];
    _peopleLabel.adjustsFontSizeToFitWidth = YES;
    _peopleLabel.text = dic[@"fittingCrowd"];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//播放材料准备视频
- (IBAction)playMaterialVideo:(id)sender {
    NSDictionary *dic = _dataArray[_currentPage];
    NSLog(@"dic==%@",dic);
    NSString *path = dic[@"materialVideoPath"];
    NSString *fittingRestriction = dic[@"fittingRestriction"];
    NSString *method = dic[@"method"];
    NSLog(@"fittingRestriction==%@",fittingRestriction);
    NSLog(@"method=%@",method);
    
    //使用系统播放器来播放视频
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:path]];
    
    [self presentMoviePlayerViewControllerAnimated:player];
}
//播放制作过程视频
- (IBAction)playMakeVideo:(id)sender {
    NSDictionary *dic = _dataArray[_currentPage];
    
    NSString *path = dic[@"productionProcessPath"];
    
    //使用系统播放器来播放视频
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:path]];
    
    [self presentMoviePlayerViewControllerAnimated:player];
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *imgPath = dic[@"imagePathLandscape"];
    [cell.foodImgView setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"首页-默认底图"]];
    return cell;
}

#pragma mark -scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPage = scrollView.contentOffset.x/320;
    
    //滑动页面,更新菜名
    [self updateFoodInfo:_currentPage];
//    NSLog(@"_currentPage=%d",_currentPage);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //取到当前页面字典
    NSDictionary *dic = _dataArray[_currentPage];
    //取到原料和调料,ID
    NSString *materialString = dic[@"fittingRestriction"];
    NSString *flavouringString = dic[@"method"];
    NSString *vegetable_id = dic[@"vegetable_id"];
    
    //只有材料界面才传下面两个参
    if ([segue.identifier isEqualToString:@"PushToMaterial"])
    {
        [segue.destinationViewController setValue:materialString forKey:@"materialString"];
        [segue.destinationViewController setValue:flavouringString forKey:@"flavouringString"];
    }
    
    [segue.destinationViewController setValue:vegetable_id forKey:@"foodID"];
}


@end
