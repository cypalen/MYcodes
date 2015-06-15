//
//  CYLimitViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYLimitViewController.h"

@interface CYLimitViewController ()

@end

@implementation CYLimitViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setTabBarItemTitle:@"限免" imageName:@"tabbar_limitfree" selectedImageName:@"tabbar_limitfree_press"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册类
    //[self.tabView registerClass:[CYFirstCell class] forCellReuseIdentifier:kCYCELL_ID];
    
    //注册xib
    [self.tabView registerNib:[UINib nibWithNibName:kCYLIMIT_CELL bundle:nil] forCellReuseIdentifier:kCYCELL_ID];
    
    [self setNavigationBarTitle:@"分类" imageName:@"buttonbar_action" pos:LEFT_ITEM action:@selector(leftBtnClick)];
    [self setNavigationBarTitle:@"设置" imageName:@"buttonbar_action" pos:RIGHT_ITEM action:@selector(rightBtnClick)];
    
    [self downLoadWithURL:LIMIT_URL];
    
}

-(NSString *)getTimeStr:(NSString *)toDataStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss.S"];
    NSDate *toData = [format dateFromString:toDataStr];
    
    //得到当前时间
    NSDate *date = [NSDate date];
    //时间的减法  ---> 日历对象
    NSCalendar *cale = [NSCalendar currentCalendar];
    
    int mask = kCFCalendarUnitYear | kCFCalendarUnitMonth |
        kCFCalendarUnitDay  |
        kCFCalendarUnitHour |
        kCFCalendarUnitMinute |
        kCFCalendarUnitSecond ;
    
    if(date && toData)
    {
        NSDateComponents *component = [cale components:mask fromDate:date toDate:toData options:0];
    
        return [NSString stringWithFormat:@"%02d:%02d:%02d",component.hour,component.minute,component.second];
    }
    return @"";
}

//重写父类的方法
-(void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [super updateCell:cell indexPath:indexPath];
    CYLimitCell *limitCell = (CYLimitCell *)cell;
    CYAppModel *model = self.dataArray[indexPath.row];
    limitCell.timeLabel.text = [NSString stringWithFormat:@"剩余:%@",[self getTimeStr:model.appExpireDatetime]];
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
