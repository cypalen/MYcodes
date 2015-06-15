//
//  CYSettingViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYSettingViewController.h"
#import "CYDataBase.h"
#import "CYShowStroeViewController.h"

@interface CYSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
- (IBAction)storeBtnClick:(id)sender;

@end

@implementation CYSettingViewController
{
    NSMutableArray *_storeModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _storeModelArray = [[CYDataBase sharedDataBase] getStoreModel];
    self.numberLabel.text = [NSString stringWithFormat:@"%d",_storeModelArray.count];
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

- (IBAction)storeBtnClick:(id)sender {
    CYShowStroeViewController *showStore = [[CYShowStroeViewController alloc] init];
    
    showStore.storeArray = _storeModelArray;
    [self.navigationController pushViewController:showStore animated:YES];
}
@end
