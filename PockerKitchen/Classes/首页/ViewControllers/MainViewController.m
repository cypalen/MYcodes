//
//  MainViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/15.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "MainViewController.h"
#import "HttpRequestManager.h"
#import "MainCell.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"
@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int _currentPage;
    NSMutableArray *_dataArray;
    BOOL _isFitting;
    NSInteger _selectRow;//选择的行
}
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearAndMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseCalendarLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *fitAndAvoidLabel;
@property (weak, nonatomic) IBOutlet UIButton *pageButton;


@end

@implementation MainViewController
//在StoryBoard初始化方法,其他的init不走
//initWithCoder会在初始化控件之前调用,因为它们还是null
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _currentPage = 1;
        _dataArray = [[NSMutableArray alloc]init];
        _isFitting = YES;
        
//        NSLog(@"_mainCollectionView==%@",_mainCollectionView);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self getTodayInfo];
}
- (void)getTodayInfo
{
    //获取今天的信息
    NSDictionary *dic =  [Helper getTodayDate];
    NSString *year = dic[@"year"];
    NSString *month = dic[@"month"];
    NSString *day = dic[@"day"];
    
    _dayLabel.text = day;
    _yearAndMonthLabel.text = [NSString stringWithFormat:@"%@-%@",year,month];
    
    [[HttpRequestManager shareInstance]getFitAndAvoidInfoWithYear:year AndMonth:month AndDay:day AndCompletionSuccess:^(HttpRequestManager *manager, id object) {
        
        NSDictionary *dic = object;
//        NSLog(@"dic==%@",dic);
        
        //刷新农历
        _chineseCalendarLabel.text = dic[@"LunarCalendar"];
        //宜的信息
        NSString *fitting = dic[@"alertInfoFitting"];
        //忌的信息
        NSString *avoid = dic[@"alertInfoAvoid"];
        
        [self showFitting:fitting AndAvoid:avoid];
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error) {
        
        NSLog(@"获取宜和忌信息失败,error=%@",error);
        
    }];
}
//跑马灯效果
-(void)showFitting:(NSString *)fitting AndAvoid:(NSString *)avoid
{
    //让子视图不超出边界
    _bgView.clipsToBounds = YES;
    
    if (_isFitting)
    {
        //宜
        _iconImgView.image = [UIImage imageNamed:@"首页-宜"];
        
        _fitAndAvoidLabel.text = fitting;
        
//        NSLog(@"fitting==%@",fitting);
        
#if 0
        //这种方式不会将图片放到内存中
        NSString *path = [[NSBundle mainBundle]pathForResource:@"" ofType:@""];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
#endif
        
        //求出文字占用的宽度
        CGFloat with = [Helper widthOfString:fitting font:_fitAndAvoidLabel.font height:_fitAndAvoidLabel.bounds.size.height];
        
        //修改label的宽度
        _fitAndAvoidLabel.frame = CGRectMake(_fitAndAvoidLabel.frame.origin.x, _fitAndAvoidLabel.frame.origin.y, with, _fitAndAvoidLabel.frame.size.height);
        
        
        //求出跑马灯效果的时间
        //跑马灯的总路程是,文字宽度+背景条宽度
        //每个像素跑0.02秒
        CGFloat time = (with +_bgView.bounds.size.width)*0.02;
        
        
        CGRect labelFrame = _fitAndAvoidLabel.frame;
        //将label移动到背景条的最末尾
        labelFrame.origin.x = _bgView.frame.size.width;
        _fitAndAvoidLabel.frame = labelFrame;
        
        //跑动效果
        [UIView animateWithDuration:time animations:^{
            
            CGRect labelFrame = _fitAndAvoidLabel.frame;
            //让label跑出进度条边界
            labelFrame.origin.x = _fitAndAvoidLabel.frame.size.width * -1;
            _fitAndAvoidLabel.frame = labelFrame;
            
        } completion:^(BOOL finished) {
            //宜跑完了,轮到忌了
            _isFitting = NO;
            //再调一次自己
            [self showFitting:fitting AndAvoid:avoid];
        }];
        
    }else
    {
        //忌
        _iconImgView.image = [UIImage imageNamed:@"首页-忌"];
        
        _fitAndAvoidLabel.text = avoid;
        
        //求出文字占用的宽度
        CGFloat with = [Helper widthOfString:avoid font:_fitAndAvoidLabel.font height:_fitAndAvoidLabel.bounds.size.height];
        //求出跑马灯效果的时间
        //跑马灯的总路程是,文字宽度+背景条宽度
        //每个像素跑0.02秒
        CGFloat time = (with +_bgView.bounds.size.width)*0.01;
        
        
        CGRect labelFrame = _fitAndAvoidLabel.frame;
        //将label移动到背景条的最末尾
        labelFrame.origin.x = _bgView.frame.size.width;
        _fitAndAvoidLabel.frame = labelFrame;
        
        //跑动效果
        [UIView animateWithDuration:time animations:^{
            
            CGRect labelFrame = _fitAndAvoidLabel.frame;
            //让label跑出进度条边界
            labelFrame.origin.x = _bgView.frame.size.width * -1;
            _fitAndAvoidLabel.frame = labelFrame;
            
        } completion:^(BOOL finished) {
            //宜跑完了,轮到忌了
            _isFitting = YES;
            //再调一次自己
            [self showFitting:fitting AndAvoid:avoid];
        }];
    }
}
- (void)getData
{
    //请求数据
    [[HttpRequestManager shareInstance]getMainInfoWithPage:_currentPage AndCompletionSuccess:^(HttpRequestManager *manager, id object) {
        
        NSArray *array = object;
        //把这个array添加到数据源中,添加一组
        [_dataArray addObjectsFromArray:array];
        
        //刷表
        [_mainCollectionView reloadData];
        
        //第一组数据才默认加载菜名
        if (_currentPage ==1)
        {
            if (_dataArray.count >0)
            {
                //默认显示第0个菜名
                [self updateFoodName:0];
            }
        }
       
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error) {
        
        NSLog(@"请求首页数据失败,error==%@",error);
    }];
}
//更新菜名
- (void)updateFoodName:(NSInteger)index
{
    //数组中一个元素对应一页
    NSDictionary *dic = _dataArray[index];
    _chineseNameLabel.text = dic[@"name"];
    _englishNameLabel.text = dic[@"englishName"];
}

#pragma scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //取到当前页
    int page = scrollView.contentOffset.x/320;
    
    //滑动一页,更新一次菜名
    [self updateFoodName:page];
    
    //求出button的位置
    CGFloat x = (221/_dataArray.count)*page;
    
    CGRect buttonFrame = _pageButton.frame;
    //20是起始偏移量
    buttonFrame.origin.x = x+20;
    _pageButton.frame = buttonFrame;
    
    //设置page值
    [_pageButton setTitle:[NSString stringWithFormat:@"%d",page+1] forState:UIControlStateNormal];
    //adjustsFontSizeToFitWidth  如果label不够大,那么文字会缩小
    _pageButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果在最后一页拉动
    if (scrollView.contentOffset.x > (_dataArray.count-1 )*320)
    {
        //进行下一组数据的加载
        _currentPage++;
        [self getData];
    }
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    //取到字典
    NSDictionary *dic = _dataArray[indexPath.row];
    //取到图片
    NSString *imgPath = dic[@"imagePathLandscape"];
    [cell.foodImgView setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"首页-默认底图"]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //选择了其中一页
//    NSLog(@"didSelectItemAtIndexPath");
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
//    NSLog(@"shouldSelectItemAtIndexPath");
    //取到选择中行
    _selectRow = indexPath.row;
    return YES;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //storyBoard传参使用的方法
//     NSLog(@"prepareForSegue");
     //如果跳转的identifier是PushToDetail就跳转
     if ([segue.identifier isEqualToString:@"PushToDetail"])
     {
         //KVC传值,key是下一个页面的属性
         [segue.destinationViewController setValue:_dataArray forKey:@"dataArray"];
         [segue.destinationViewController setValue:@(_selectRow) forKey:@"index"];
     }
    
 }

//shouldSelectItemAtIndexPath-->prepareForSegue-->didSelectItemAtIndexPath
//所以在shouldSelectItemAtIndexPath方法中取到行,然后在prepareForSegue中传递
@end
