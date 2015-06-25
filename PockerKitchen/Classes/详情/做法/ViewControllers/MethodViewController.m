//
//  MethodViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "MethodViewController.h"
#import "HttpRequestManager.h"
#import "MethodCell.h"
#import "UIImageView+AFNetworking.h"
@interface MethodViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *methodTableView;

@end

@implementation MethodViewController
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
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:_methodTableView.bounds];
    imgView.image = [UIImage imageNamed:@"背景图"];
    _methodTableView.backgroundView = imgView;
}
- (void)getData
{
    [[HttpRequestManager shareInstance]getFoodDetailWithID:_foodID AndType:2 AndCompletionSuccess:^(HttpRequestManager *manager, id object) {
        
        NSArray *array = object;
        //将传过来的数组加入数据源
        [_dataArray addObjectsFromArray:array];
        
        [_methodTableView reloadData];
    } AndFailure:^(HttpRequestManager *manager, NSError *error) {
        
        NSLog(@"请求做法数据失败,error==%@",error);
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MethodCell"];
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:dic[@"imagePath"]]];
    cell.numberLabel.text = dic[@"order_id"];
    cell.titleLabel.text = dic[@"describe"];
    return cell;
}


@end
