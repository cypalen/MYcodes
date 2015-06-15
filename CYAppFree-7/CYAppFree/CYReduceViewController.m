//
//  CYReduceViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYReduceViewController.h"

@interface CYReduceViewController ()

@end

@implementation CYReduceViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setTabBarItemTitle:@"降价" imageName:@"tabbar_reduceprice" selectedImageName:@"tabbar_reduceprice_press"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:@"分类" imageName:@"buttonbar_action" pos:LEFT_ITEM action:@selector(leftBtnClick)];
    [self setNavigationBarTitle:@"设置" imageName:@"buttonbar_action" pos:RIGHT_ITEM action:@selector(rightBtnClick)];
    
    [self.tabView registerNib:[UINib nibWithNibName:kCYLIMIT_CELL bundle:nil] forCellReuseIdentifier:kCYCELL_ID];
    
    [self downLoadWithURL:REDUCE_URL];
}

-(void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [super updateCell:cell indexPath:indexPath];
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
