//
//  SmartSearchViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/18.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "SmartSearchViewController.h"
#import "GDataXMLNode.h"
#import "LargeCell.h"
#import "FoodView.h"
#import "HttpRequestManager.h"
#import "SmartSearchResultViewController.h"
#import "MBProgressHUD.h"
@interface SmartSearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_selectArray;//选中的材料
   
}
@property (weak, nonatomic) IBOutlet UICollectionView *largeCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *topView;

@end

@implementation SmartSearchViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        _selectArray = [[NSMutableArray alloc]init];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}
- (void)getData
{
    //解析XML文件
    //寻找文件路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"material" ofType:@"xml"];
    NSLog(@"%@",path);
    //将文件读出来
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    
    //将二进制转成xml格式文件
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
    //取到根节点,从根节点开始解析
    GDataXMLElement *root = [document rootElement];

    //碰到向下的箭头直接用数组去装
    GDataXMLElement *entity =[root elementsForName:@"entity"][0];
    
    //取到entity所有子节点
    NSArray *tblMmaterialType = [entity elementsForName:@"tblMmaterialType"];
    
    //对tblMmaterialType子节点进行解析
    for (GDataXMLElement *element in tblMmaterialType)
    {
        NSString *largeName = [element subElementValue:@"name"];
        
        NSArray *tblMaterial = [element elementsForName:@"tblMaterial"];
        
        NSMutableArray *littleArray = [[NSMutableArray alloc]init];
        for (GDataXMLElement *element in tblMaterial)
        {
            NSString *littleName = [element subElementValue:@"name"];
            NSString *imgPath = [element subElementValue:@"imageFilename"];
            NSString *materialId = [element subElementValue:@"materialId"];
            
            NSDictionary *littleDic = @{@"littleName":littleName,@"imgPath":imgPath,@"materialId":materialId};
            [littleArray addObject:littleDic];
        }
        
        NSDictionary *largeDic = @{@"largeName":largeName,@"littleArray":littleArray};
        
        [_dataArray addObject:largeDic];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchAction:(id)sender
{
    if (_selectArray.count == 0)
    {
        return;
    }
    
    //拼接ID进行搜索
    NSMutableString *idString = [[NSMutableString alloc]init];
    //拼接材料名,用于下一个页面的显示
    NSMutableString *titleString = [[NSMutableString alloc]init];
    for (int i=0;i<_selectArray.count;i++)
    {
        NSDictionary *dic = _selectArray[i];
        NSString *materialID = dic[@"materialId"];
        NSString *name = dic[@"littleName"];
        
        //拼接
        if (i ==0)
        {
            [idString appendString:materialID];
            [titleString appendString:name];
        }
        else
        {
            [idString appendFormat:@",%@",materialID];
            [titleString appendFormat:@"+%@",name];
        }
    }
    //开始搜索,转圈
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //发起搜索请求
    [[HttpRequestManager shareInstance]smartSearchByID:idString AndPage:1 AndPageRecord:20 AndCompletionSuccess:^(HttpRequestManager *manager, id object)
    {
        //搜索成功,结束转圈
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *array = object;
        //进行页面跳转
        //取到storyBoard中未连线的控制器
        SmartSearchResultViewController *result = [self.storyboard instantiateViewControllerWithIdentifier:@"SmartSearchResult"];
        result.titleString = titleString;
        result.idString = idString;
        //创建一个可变数组,传递过去
        result.dataArray = [NSMutableArray arrayWithArray:array];
        //按正常使用推出
        [self.navigationController pushViewController:result animated:YES];
        
    } AndFailure:^(HttpRequestManager *manager, NSError *error)
     {
         //搜索失败,结束转圈
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"智能搜索失败,error==%@",error);
    }];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LargeCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.titleLabel.text = dic[@"largeName"];
    //传过去数组,并且更新数据
    cell.dataArray = dic[@"littleArray"];
    cell.callBack = ^(NSDictionary *dic)
    {
        //如果该材料已经添加,则不允许添加
        //判断这个对象是不是在数组中
        if ([_selectArray containsObject:dic])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该材料已经添加,不允许重复添加" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        
        //如果数组中个数大于6个,则不允许添加
        if (_selectArray.count >=6)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"材料超过6个,不允许添加" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        
        //选中一个材料,就将它加到数组中
        [_selectArray addObject:dic];
        [self refreshTopView];
    };
    [cell.littleCollectionView reloadData];
    [cell.littleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    return cell;
}

#pragma mark- 更新topView
#define originX 20  //起点X
#define originY 5   //起点Y
#define with    80  //宽
#define height  25  //高
#define space   10  //间隙
- (void)refreshTopView
{
    //清除以前的view
    for (UIView *v in _topView.subviews)
    {
        [v removeFromSuperview];
    }
    for (int i=0; i<_selectArray.count; i++)
    {
        NSDictionary *dic = _selectArray[i];
        
        //根据选中的材料个数,来进行布局
        FoodView *view = [[NSBundle mainBundle]loadNibNamed:@"FoodView" owner:self options:0][0];
        //0 1 2 3 4 5
    //%3  0 1 2 0 1 2
   // /3  0 0 0 1 1 1
        view.frame = CGRectMake(originX +(with+space)*(i%3), originY+(height+space)*(i/3), with, height);
        view.foodNameLabel.text = dic[@"littleName"];
        view.foodNameLabel.adjustsFontSizeToFitWidth = YES;
        //打上Tag,用来删除
        view.deleteButton.tag = i;
        [view.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_topView addSubview:view];
        
    }
}
//删除事件
//当你想拷贝一串代码的时候,就把它封装起来
- (void)deleteAction:(UIButton *)button
{
    //删除对应tag的对象
    [_selectArray removeObjectAtIndex:button.tag];
    //重新更新视图
    [self refreshTopView];
}

@end
