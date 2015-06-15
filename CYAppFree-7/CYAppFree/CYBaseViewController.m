//
//  CYBaseViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYBaseViewController.h"
#import "CYLimitViewController.h"
#import "CYSubjectViewController.h"
#import "CYCateViewController.h"
#import "CYSettingViewController.h"

@interface CYBaseViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation CYBaseViewController

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

-(UITableView *)tabView
{
    if(_tabView == nil)
    {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(kCYZERO, kCYNAVBAR_HEIGHT, kCYWINDOW_WIDTH, kCYWINDOW_HEIGHT - kCYNAVBAR_HEIGHT - kCYTABBAR_HEIGHT) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
    }
    
    return _tabView;
}

-(void)setTabBarItemTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)seclectedImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:seclectedImageName];
    
    //渲染模式  UIImageRenderingModeAlwaysOriginal
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
}

-(void)leftBtnClick
{
    CYCateViewController *cate = [[CYCateViewController alloc] init];
    [self.navigationController pushViewController:cate animated:YES];
}
-(void)rightBtnClick
{
    CYSettingViewController *setting = [[CYSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)setNavigationBarTitle:(NSString *)title imageName:(NSString *)imageName pos:(ITEM_TYPE)pos action:(SEL)action
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    if(pos == LEFT_ITEM)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCYCELL_ID];
    //子类必须注册  xib  或者 cell 所使用的类
    [self updateCell:cell indexPath:indexPath];
    
    return cell;
}

//父类刷新cell的方法  ---->  专门为子类提供的  ---> 如果子类中有刷新相同的内容  一般放到父类中
-(void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    if(indexPath.row % 2 == 0)
    {
        imageView.image = [UIImage imageNamed:@"cate_list_bg1"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"cate_list_bg2"];
    }
    cell.backgroundView = imageView;
    
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor = [UIColor redColor];
    cell.selectedBackgroundView = view;
    
    CYLimitCell *limitCell = (CYLimitCell *)cell;
    CYAppModel *model = self.dataArray[indexPath.row];
    limitCell.nameLabel.text = model.appName;
    
    [limitCell.headImage sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    limitCell.priceLabel.text = model.appPrice;
    limitCell.cateLabel.text = model.appCategoryName;
    
    limitCell.infoLabel.text = [NSString stringWithFormat:@"分享:%@    收藏:%@   下载:%@",model.appShares,model.appFavorites,model.appDownLoads];
    
    [limitCell.starView setStar:[model.appStarCurrent floatValue]];
    
}


/*
 {
 applications =     (
 {jiugangcainaxie
 applicationId = 455680974;
 categoryId = 6014;
 categoryName = Game;
 currentPrice = 0;
 description = "\U754c
 */
-(void)downLoadWithURL:(NSString *)urlStr
{
    [[CYHttpRequest sharedManager] httpRequestWithURL:urlStr success:^(NSURLResponse *response, id dataObj) {
        if([self isKindOfClass:[CYSubjectViewController class]])
        {
            //解析 专题 界面中的数据
            NSArray *subjectArray = [NSJSONSerialization JSONObjectWithData:dataObj options:NSJSONReadingMutableContainers error:nil];
            
            for (NSDictionary *subDict in subjectArray) {
                CYSubjectModel *subModel = [[CYSubjectModel alloc] initWithDic:subDict];
                [self.dataArray addObject:subModel];
            }
        }
        else
        {
            //解析 其他三个 界面中的数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataObj options:NSJSONReadingMutableContainers error:nil];
            NSArray *appArray = dic[@"applications"];
            
            for (NSDictionary *appDict in appArray) {
                CYAppModel *appModel = [[CYAppModel alloc] initWithDic:appDict];
                
                [self.dataArray addObject:appModel];
            }
        }
        
        [self.tabView reloadData];
    } failure:^(NSURLResponse *response, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tabView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isKindOfClass:[CYSubjectViewController class]])
    {
        return 320.0f;
    }
    else
    {
        return 100.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(![self isKindOfClass:[CYSubjectViewController class]])
    {
        CYAppModel *model = self.dataArray[indexPath.row];
        CYDetailViewController *detail = [[CYDetailViewController alloc] init];
        detail.appID = model.appID;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
