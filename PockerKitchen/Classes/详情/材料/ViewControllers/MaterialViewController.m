//
//  MaterialViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "MaterialViewController.h"
#import "MaterialCell.h"
#import "HttpRequestManager.h"
#import "MaterialModel.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"
@interface MaterialViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    CGFloat _materialStringHeight;
    CGFloat _flavouringStringHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;

@end

@implementation MaterialViewController
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
    
    NSLog(@"_materialString=%@,_flavouringString=%@,_foodID=%@",_materialString,_flavouringString,_foodID);
    
   //UITableViewStylePlain    段头不会跟随表格移动
   //UITableViewStyleGrouped  段头可以跟随表格移动
    [self createTableBackView];
    [self getData];
    [self calculateHeight];
}
- (void)calculateHeight
{
    //原料和调料字符高度计算
    _materialStringHeight = [Helper heightOfString:_materialString font:[UIFont systemFontOfSize:14] width:200];
    _flavouringStringHeight = [Helper heightOfString:_flavouringString font:[UIFont systemFontOfSize:14] width:200];
}
- (void)getData
{
    [[HttpRequestManager shareInstance]getFoodDetailWithID:_foodID AndType:1 AndCompletionSuccess:^(HttpRequestManager *manager, id object) {
        
        NSArray *array = object;
        for (int i=0; i<array.count; i++)
        {
            NSDictionary *dic = array[i];
            //第一个段的数据
            if (0 == i)
            {
                MaterialModel *model = [[MaterialModel alloc]init];
                model.imgPath = dic[@"imagePath"];
                model.title = @"";
                [_dataArray addObject:model];
            }
            //取第二个段,第二个段装的是一个数组
            NSArray  *TblSeasoningArray = dic[@"TblSeasoning"];
            if (TblSeasoningArray.count >0)
            {
                NSMutableArray *flavouringArray = [[NSMutableArray alloc]init];
                
                for (NSDictionary *dic in TblSeasoningArray)
                {
                    MaterialModel *model = [[MaterialModel alloc]init];
                    model.imgPath = dic[@"imagePath"];
                    model.title = dic[@"name"];
                    [flavouringArray addObject:model];
                }
                [_dataArray addObject:flavouringArray];
            }
            
        }
        //请求数据完毕
        [_materialTableView reloadData];
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error) {
        
        NSLog(@"请求材料数据失败,error=%@",error);
        
    }];
}
- (void)createTableBackView
{
    //给表格加上背景
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:_materialTableView.bounds];
    imgView.image = [UIImage imageNamed:@"背景图"];
    _materialTableView.backgroundView = imgView;
}
//返回上一级
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//返回根视图
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
    //如果是第0段,返回1
    //如果是第1段,则返回数组个数
    if (section == 0)
    {
        return 1;
    }else
    {
        NSArray *array = _dataArray[section];
        return array.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
    //如果是第0段,直接取模型
    //如果是第1段,取数组
    if (indexPath.section ==0)
    {
        MaterialModel *model = _dataArray[indexPath.row];
        [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgPath]];
        cell.titleLabel.text = @"";
    }else
    {
        NSArray *array = _dataArray[indexPath.section];
        MaterialModel *model = array[indexPath.row];
        [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgPath]];
        cell.titleLabel.text = model.title;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回cell高度
    return 170;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _materialStringHeight +10;
    }else
    {
        return _flavouringStringHeight +10;
    }
}
//段头的定制
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, _materialStringHeight+10)];
        imgView.image = [UIImage imageNamed:@"背景图"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 50, 20)];
        titleLabel.text = @"原料:";
        titleLabel.textColor = [UIColor blueColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [imgView addSubview:titleLabel];
        
        UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, _materialStringHeight)];
        contentLable.text = _materialString;
        contentLable.font = [UIFont systemFontOfSize:14];
        contentLable.numberOfLines = 0;
        [imgView addSubview:contentLable];
        
        return imgView;
    }else
    {
        //返回调料段头
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, _flavouringStringHeight+10)];
        imgView.image = [UIImage imageNamed:@"背景图"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 50, 20)];
        titleLabel.text = @"调料:";
        titleLabel.textColor = [UIColor blueColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [imgView addSubview:titleLabel];
        
        UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, _flavouringStringHeight)];
        contentLable.text = _flavouringString;
        contentLable.font = [UIFont systemFontOfSize:14];
        contentLable.numberOfLines = 0;
        [imgView addSubview:contentLable];
        
        return imgView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
@end
