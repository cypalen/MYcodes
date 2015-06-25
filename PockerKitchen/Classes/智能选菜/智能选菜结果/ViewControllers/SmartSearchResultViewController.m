//
//  SmartSearchResultViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/18.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "SmartSearchResultViewController.h"
#import "ResultCell.h"
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"
#import "MBProgressHUD.h"
@interface SmartSearchResultViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
     int _currentPage;//当前页
     int _selectIndex;//点击了哪个cell
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *resultCollectionView;

@end

@implementation SmartSearchResultViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _currentPage = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLabel.text = _titleString;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:dic[@"imagePathThumbnails"]]];
    cell.praiseLabel.text = dic[@"clickCount"];
    cell.saveLabel.text = dic[@"agreementAmount"];
    if ([cell.saveLabel.text isEqualToString:@""]) {
        cell.saveLabel.text = @"0";
    }
    cell.nameLabel.text = dic[@"name"];
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //即将点击一个cell的时候
    //将行号保存起来,便于下面的传递
    _selectIndex = indexPath.row;
    return YES;
}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //当scrollView拉到最下面超出边界的时候,请求下一组数据
    if (scrollView.contentOffset.y+ _resultCollectionView.frame.size.height >(_dataArray.count +1)/2*(120+10) )
    {
        _currentPage ++;
        [self getNextPageInfo];
    }
}

#pragma mark- 请求下一页数据
- (void)getNextPageInfo
{
    //发起请求,显示转圈
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpRequestManager shareInstance]smartSearchByID:_idString AndPage:_currentPage AndPageRecord:20 AndCompletionSuccess:^(HttpRequestManager *manager, id object)
    {
        //获取数据成功,转圈消失
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *array = object;
        //将下拉刷新回来的数据追加到数据源
        [_dataArray addObjectsFromArray:array];
        //重新刷新页面
        [_resultCollectionView reloadData];
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error)
    {
        //获取数据失败,转圈消失
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"下拉刷新失败,error=%@",error);
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //传递参数
    [segue.destinationViewController setValue:_dataArray forKey:@"dataArray"];
    [segue.destinationViewController setValue:@(_selectIndex) forKey:@"index"];
}


@end
