//
//  FitAndAvoidViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "FitAndAvoidViewController.h"
#import "HttpRequestManager.h"
#import "FittingCell.h"
#import "UIImageView+AFNetworking.h"
#import "HeadView.h"
@interface FitAndAvoidViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSString *_foodName;
    NSString *_foodImgPath;
}
@property (weak, nonatomic) IBOutlet UITableView *fittingTableView;
@end

@implementation FitAndAvoidViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self createBackView];
}
- (void)createBackView
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:_fittingTableView.bounds];
    imgView.image = [UIImage imageNamed:@"背景图"];
    _fittingTableView.backgroundView = imgView;
}
- (void)getData
{
    //请求数据
    [[HttpRequestManager shareInstance]getFoodDetailWithID:_foodID AndType:3 AndCompletionSuccess:^(HttpRequestManager *manager, id object) {
        NSArray *array = object;
        for (NSDictionary *dic in array)
        {
            _foodName = dic[@"materialName"];
            _foodImgPath = dic[@"imageName"];
            NSArray *FittingArray = dic[@"Fitting"];
            NSArray *GramArray = dic[@"Gram"];
            if (FittingArray.count >0)
            {
                //相宜信息
                [_dataArray addObject:FittingArray];
            }
            
            if (GramArray.count >0)
            {
                //相克信息
                [_dataArray addObject:GramArray];
            }
        }
        //刷表
        [_fittingTableView reloadData];
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error) {
        NSLog(@"获取相宜相克失败,error=%@",error);
    }];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _dataArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FittingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FittingCell"];
    NSArray *array = _dataArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:dic[@"imageName"]]];
    cell.titleLabel.text = dic[@"materialName"];
    cell.describeLabel.text = dic[@"contentDescription"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //去掉段尾
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    imgView.image = [UIImage imageNamed:@"背景图"];
    //取到定制的xib文件
    HeadView *head = [[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:0][0];
    head.frame = CGRectMake(20, 10, 281, 40);
    [imgView addSubview:head];
    
    if (section ==0)
    {
        head.fittingLabel.text = @"相宜";
        head.chineseDescribeLabel.text = [NSString stringWithFormat:@"%@与下列食物相宜",_foodName];
    }else
    {
        head.fittingLabel.text = @"相克";
        head.chineseDescribeLabel.text = [NSString stringWithFormat:@"%@与下列食物相克",_foodName];
        
        head.fittingLabel.backgroundColor = [UIColor redColor];
        head.chineseDescribeLabel.textColor = [UIColor redColor];
        head.englishDescribeLabel.textColor = [UIColor redColor];
    }
    [head.imgView setImageWithURL:[NSURL URLWithString:_foodImgPath]];
    return imgView;
}
@end
