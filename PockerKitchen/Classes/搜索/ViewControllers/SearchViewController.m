//
//  SearchViewController.m
//  PockerKitchen
//仿
//  Created by liuyuecheng on 15/6/19.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "FoodView.h"
#import "HttpRequestManager.h"
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray; //最大的数据源
    NSMutableArray *_titleArray;//标题数组
    NSMutableArray *_selectArray;//选中的数组
    NSInteger _selectSection;//点击的section
}
@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SearchViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        _selectArray = [[NSMutableArray alloc]init];
        _titleArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    [self getData];
}
- (void)getData
{
    //从工程中取出Plist文件
    NSString *path = [[NSBundle mainBundle]pathForResource:@"searchData" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    //拿到标题
    NSArray *titleArray = dic[@"titles"];
    [_titleArray addObjectsFromArray:titleArray];
    
    for (int i=0; i<5;i++)
    {
        //@'"0"  @"1"
        NSString *order = [NSString stringWithFormat:@"%d",i];
        
        NSArray *array = dic[order];
        //每个段的数组
        NSMutableArray *foodArray = [[NSMutableArray alloc]init];
        for (NSString *string in array)
        {
            //string  菜系-川菜
            NSString *type =[self typeFromString:string];
            NSString *name =[self nameFromString:string];
            
            NSDictionary *dic = @{@"type":type,@"name":name};
            [foodArray addObject:dic];
        }
        //将每个段的数组加入最大的数据源
        [_dataArray addObject:foodArray];
    }
//    NSLog(@"_dataArray=%@",_dataArray);
    //数据加载完毕,刷表
    [_tableView reloadData];
}
//取到菜系
- (NSString *)typeFromString:(NSString *)string
{
    //通过 - 来进行字符串拆分
    NSArray *array = [string componentsSeparatedByString:@"-"];
    if (array.count>0)
    {
        return array[0];
    }
    return nil;
}
//取到川菜
- (NSString *)nameFromString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"];
    if (array.count>=2) {
        return array[1];
    }
    return nil;
}
- (void)addObserver
{
    //键盘抬起事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘掉下事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    //取到键盘size
    CGSize kbSize=[[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    //将topView移动到键盘之上
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height-kbSize.height-_bottomView.frame.size.height, _bottomView.frame.size.width, _bottomView.frame.size.height);
    
    NSLog(@"_bottomView=%@",_bottomView);
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    //键盘掉下
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height-_bottomView.frame.size.height, _bottomView.frame.size.width, _bottomView.frame.size.height);
}
- (void)dealloc
{
    //移除观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchAciton:(id)sender {
    //键盘掉下
    [self.view endEditing:YES];
    
    /*
     child_catalog_name：中华菜系
     taste：口味
     fitting_crowd：适宜人群
     cooking_method：烹饪方法
     effect：功效
     */
    NSString *chineseName  = @"";
    NSString *taste = @"";
    NSString *crowd = @"";
    NSString *method = @"";
    NSString *effect = @"";
    
    for (NSDictionary *dic in _selectArray)
    {
        NSString *type= dic[@"type"];
        if ([type isEqualToString:@"菜系"])
        {
            chineseName = [dic[@"name"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else if ([type isEqualToString:@"口味"])
        {
            taste = [dic[@"name"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else if ([type isEqualToString:@"人群"])
        {
            crowd = [dic[@"name"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else if ([type isEqualToString:@"烹饪"])
        {
            method = [dic[@"name"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else if ([type isEqualToString:@"功效"])
        {
            effect = [dic[@"name"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
    }
    
    NSLog(@"chineseName=%@,taste=%@,crowd=%@,method=%@,effect=%@",chineseName,taste,crowd,method,effect);
    //进行搜索
    [[HttpRequestManager shareInstance]searchByName:[_textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  AndChineseName:chineseName AndTaste:taste AndCrowd:crowd AndMethod:method AndEffect:effect AndPage:1 AndPageRecord:10 AndCompletionSuccess:^(HttpRequestManager *manager, id object)
    {
        NSArray *array = object;
        NSLog(@"array==%@",array);
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error)
    {
        NSLog(@"搜索失败,error=%@",error);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //键盘掉下
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //点中了这行,才显示cell
    if (section == _selectSection)
    {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    //取到数组
    NSArray *array = _dataArray[indexPath.section];
    //刷新
    [self refreshScrollView:cell.myScrollView WithArray:array WithSection:indexPath.section];
    return cell;
}
//返回段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//段头定制
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 320, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"搜索-类别筛选"] forState:UIControlStateNormal];
    //设置标题
    [button setTitle:_titleArray[section] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = 100+section;
    [button addTarget:self action:@selector(headSection:) forControlEvents:UIControlEventTouchUpInside];
    
    //选中高亮效果
    if (section == _selectSection)
    {
       [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
       [button setBackgroundImage:[UIImage imageNamed:@"搜索-类别筛选-选"] forState:UIControlStateNormal];
    }
    
    return button;
}
- (void)headSection:(UIButton *)button
{
    _selectSection = button.tag - 100;
    
    //刷表
    [_tableView reloadData];
}
//刷新cell中的scrollView
- (void)refreshScrollView:(UIScrollView *)scrollView WithArray:(NSArray *)array WithSection:(int)section
{
    //刷新scrollView之前,将所有子视图移除
    for (UIView *v in scrollView.subviews)
    {
        [v removeFromSuperview];
    }
    
    //求出scrollView的滑动宽度
    CGFloat with = array.count*65;
    scrollView.contentSize = CGSizeMake(with, 0);
    
    for (int i=0; i<array.count; i++)
    {
        //取到图片名字
        NSDictionary *dic = array[i];
        NSString *imgName = [NSString stringWithFormat:@"%@-%@",dic[@"type"],dic[@"name"]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(65*i, 2.5, 60, 60);
        [button setBackgroundImage:[UIImage imageNamed:@"搜索-分类底"] forState:UIControlStateNormal];
        [scrollView addSubview:button];
        
        //创建按钮的图片
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        imgView.image = [UIImage imageNamed:imgName];
        [button addSubview:imgView];
        
        //后面三个段,需要添加文字
         UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 50, 20)];
        if (section == 2|| section == 3 || section ==4)
        {
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 50, 20)];
            label.text =dic[@"name"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            [button addSubview:label];
        }
        
        //给button打tag,添加点击事件
        button.tag = section*100+i;
        [button addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //如果选中数组中包含这个元素,则高亮
        if ([_selectArray containsObject:dic])
        {
            [button setBackgroundImage:[UIImage imageNamed:@"搜索-分类底-选"] forState:UIControlStateNormal];
            //拼接高亮图片
            NSString *imgName = [NSString stringWithFormat:@"%@-%@1",dic[@"type"],dic[@"name"]];
            imgView.image = [UIImage imageNamed:imgName];
            
//            for (UIView *v in button.subviews)
//            {
//                if ([v isKindOfClass:[UILabel class]])
//                {
//                    UILabel *label = (UILabel *)v;
//                    label.textColor = [UIColor whiteColor];
//                }
//            }
            label.textColor = [UIColor whiteColor];
        }
    }
}
//点中按钮事件
- (void)cellButtonClick:(UIButton *)button
{
    //取到哪个段
    NSInteger section = button.tag/100;
    //取到段中第几个元素
    NSInteger index = button.tag%100;
    
    //取到点击cell对应dic
    NSArray *array = _dataArray[section];
    NSDictionary *dic = array[index];
    
    //取出type
    NSString *type = dic[@"type"];
    
    //先在selectArray中对比,如果存在改type得数据则替换.如果不存在则添加
    BOOL isExist = NO;
    for (int i =0;i<_selectArray.count;i++)
    {
        NSDictionary *dicInSelect = _selectArray[i];
        NSString *typeInSelect = dicInSelect[@"type"];
        //判断类型是否一致
        if ([typeInSelect isEqualToString:type])
        {
            isExist = YES;
            //替换
            [_selectArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    
    //不存在,则添加
    if (!isExist)
    {
        [_selectArray addObject:dic];
    }
    
    //点击一次按钮,刷新一个tableView
    [_tableView reloadData];
    
    //刷新topView
    [self refreshTopView];
}

#define originX 20  //起点X
#define originY 5   //起点Y
#define with    80  //宽
#define height  25  //高
#define space   10  //间隙
- (void)refreshTopView
{
    //每次刷新之前,先清空
    for (UIView *v in _topView.subviews)
    {
        [v removeFromSuperview];
    }
    
    for (int i=0;i<_selectArray.count;i++)
    {
        FoodView *view = [[NSBundle mainBundle]loadNibNamed:@"FoodView" owner:self options:0][0];
        view.frame = CGRectMake(originX+(with+space)*(i%3), originY+(height+space)*(i/3), with, height);
        
        NSDictionary *dic = _selectArray[i];
        view.foodNameLabel.text = dic[@"name"];
        [view.deleteButton addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
        view.deleteButton.tag = 500+i;
        [_topView addSubview:view];
    }
}
//删除topView其中一项
- (void)deleteView:(UIButton *)button
{
    [_selectArray removeObjectAtIndex:button.tag-500];
    [self refreshTopView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
