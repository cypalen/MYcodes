//
//  CYDetailViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYDetailViewController.h"
#import "CYConst.h"

@interface CYDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
- (IBAction)store:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *nearScrollView;
@end

@implementation CYDetailViewController
{
    CYAppModel *_detalModel;
    NSMutableArray *_detailArray;
    NSMutableArray *_nearArray;
    BOOL _isExist;
}

-(void)updateDetailUI
{
    NSInteger count = 0;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:_detalModel.appImage] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    self.nameLabel.text = _detalModel.appName;
    self.priceLabel.text = [NSString stringWithFormat:@"原价:%@  限免中 %@",_detalModel.appPrice,_detalModel.appFileSize];
    
    self.cateLabel.text = [NSString stringWithFormat:@"类型:%@  评分:%@",_detalModel.appCategoryName,_detalModel.appStarCurrent];
    
    for (NSString *imageUrl in _detailArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(count * (50 + 10), 0, 50, self.scrollView.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"account_candou"]];
        
        [self.scrollView addSubview:imageView];
        count++;
    }
    self.scrollView.contentSize = CGSizeMake(count * (50 + 10), self.scrollView.frame.size.height);
    self.scrollView.bounces = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.descLabel.text = _detalModel.appDescription;
}

-(void)updateNearUI
{
    for (NSInteger i = 0; i < _nearArray.count; i++) {
        CYAppModel *model = _nearArray[i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 60, 0, 50, self.nearScrollView.frame.size.height - 20)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"account_candou"]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * 60, self.nearScrollView.frame.size.height - 20, 50, 20)];
        
        label.text = model.appName;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.nearScrollView addSubview:label];
        [self.nearScrollView addSubview:imageView];
    }
    
    self.nearScrollView.contentSize = CGSizeMake(_nearArray.count * 60, self.nearScrollView.frame.size.height);
    self.nearScrollView.bounces = YES;
    self.nearScrollView.alwaysBounceHorizontal = YES;
    self.nearScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isExist = [[CYDataBase sharedDataBase] isExist:self.appID];
    
    if(_isExist)
    {
        [self.storeBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    
    _nearArray = [[NSMutableArray alloc] init];
    _detailArray = [[NSMutableArray alloc] init];

    //正向传值
    [[CYHttpRequest sharedManager] httpRequestWithURL:[NSString stringWithFormat:DEATIL_URL,self.appID] success:^(NSURLResponse *response, id dataObj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataObj options:NSJSONReadingMutableContainers error:nil];
        
        _detalModel = [[CYAppModel alloc] initWithDic:dic];
        
        NSArray *photos = dic[@"photos"];
        
        for (NSDictionary *photo in photos) {
            [_detailArray addObject:photo[@"smallUrl"]];
        }
        //NSLog(@"%@",model.appName);
        //刷新界面
        [self updateDetailUI];
    } failure:^(NSURLResponse *response, NSError *error) {
        
    }];
    
    [[CYHttpRequest sharedManager] httpRequestWithURL:NEAR_URL success:^(NSURLResponse *response, id dataObj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataObj options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *appArray = dic[@"applications"];
        
        for (NSDictionary *dic in appArray) {
            CYAppModel *model = [[CYAppModel alloc] initWithDic:dic];
            [_nearArray addObject:model];
        }
        //刷新界面
        [self updateNearUI];
    } failure:^(NSURLResponse *response, NSError *error) {
        
    }];
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

- (IBAction)store:(id)sender {
    UIButton *btn = sender;
    if(!_isExist)
    {
        [[CYDataBase sharedDataBase] insertModel:_detalModel];
        [btn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
}
@end
