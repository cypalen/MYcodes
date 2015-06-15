//
//  CYShowStroeViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYShowStroeViewController.h"
#import "CYStoreCell.h"
#import "CYConst.h"

@interface CYShowStroeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic) BOOL isEidt;

@end

@implementation CYShowStroeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(90, 90);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, 320, 480 - 64 - 49) collectionViewLayout:layout];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CYStoreCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.isEidt = editing;
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.storeArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    CYAppModel *model = self.storeArray[indexPath.row];
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    cell.nameLabel.text = model.appName;
    cell.closeBtn.hidden = !self.isEidt;
    
    cell.closeBtn.tag = 100 + indexPath.row;
    [cell.closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btnClick:(UIButton *)btn
{
    CYAppModel *model = self.storeArray[btn.tag - 100];
    [self.storeArray removeObjectAtIndex:btn.tag - 100];
    [[CYDataBase sharedDataBase] deleteModel:model.appID];
    [self.collectionView reloadData];
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
