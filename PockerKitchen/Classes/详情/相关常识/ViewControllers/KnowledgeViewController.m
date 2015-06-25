//
//  KnowledgeViewController.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/16.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "KnowledgeViewController.h"
#import "HttpRequestManager.h"
#import "Helper.h"
#import "UIImageView+AFNetworking.h"
@interface KnowledgeViewController ()
{
    NSString *_describeString;
    NSString *_makeString;
    NSString *_imgPath;
    
    CGFloat _describeHeight;
    CGFloat _makeHeight;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *makeButton;
@property (weak, nonatomic) IBOutlet UILabel *makeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}
- (void)getData
{
    [[HttpRequestManager shareInstance]getFoodDetailWithID:_foodID AndType:4 AndCompletionSuccess:^(HttpRequestManager *manager, id object) {
        
        NSArray *array = object;
        NSDictionary *dic = [array lastObject];
        
        _imgPath = dic[@"imagePath"];
        _describeString = dic[@"nutritionAnalysis"];
        _makeString = dic[@"productionDirection"];
        
        //数据获取完毕,刷新页面
        [self refreshUI];
    } AndFailure:^(HttpRequestManager *manager, NSError *error) {
        NSLog(@"获取相关常识失败,error=%@",error);
    }];
}
- (void)refreshUI
{
    //刷新图片
    [_imgView setImageWithURL:[NSURL URLWithString:_imgPath]];
    //计算高度
    _describeHeight = [Helper heightOfString:_describeString font:[UIFont systemFontOfSize:15] width:267];
    _makeHeight = [Helper heightOfString:_makeString font:[UIFont systemFontOfSize:15] width:267];
    
    //刷新描述信息及位置
    _describeLabel.text = [NSString stringWithFormat:@"    %@",_describeString];
    _describeLabel.frame = CGRectMake(_describeLabel.frame.origin.x, _describeLabel.frame.origin.y, 267, _describeHeight);
    
    //更改虚线的frame
    //取到_describeLabel控件的最大y值
    //CGRectGetMaxY(_describeLabel.frame)
    _lineView.frame = CGRectMake(_lineView.frame.origin.x, CGRectGetMaxY(_describeLabel.frame)+10, _lineView.frame.size.width, _lineView.frame.size.height);
    
    //更改按钮的位置
    _makeButton.frame = CGRectMake(_makeButton.frame.origin.x, CGRectGetMaxY(_lineView.frame)+10, _makeButton.frame.size.width, _makeButton.frame.size.height);
    
    //修改制作指导信息
    _makeLabel.text = [NSString stringWithFormat:@"    %@",_makeString];
    _makeLabel.frame = CGRectMake(_makeLabel.frame.origin.x, CGRectGetMaxY(_makeButton.frame)+10, 267, _makeHeight);
    
    //修改scrollview的contentSize
    _scrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(_makeLabel.frame)+10);
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backToHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
