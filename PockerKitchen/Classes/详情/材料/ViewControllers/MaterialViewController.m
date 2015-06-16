//
//  MaterialViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "MaterialViewController.h"
#import "MaterialCell.h"
@interface MaterialViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;

@end

@implementation MaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"_materialString=%@,_flavouringString=%@,_foodID=%@",_materialString,_flavouringString,_foodID);
    
   //UITableViewStylePlain    段头不会跟随表格移动
   //UITableViewStyleGrouped  段头可以跟随表格移动
    [self createTableBackView];
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MaterialCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回cell高度
    return 170;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
@end
