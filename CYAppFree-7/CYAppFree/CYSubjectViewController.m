//
//  CYSubjectViewController.m
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYSubjectViewController.h"
#import "CYSubAppModel.h"

@interface CYSubjectViewController ()

@end

@implementation CYSubjectViewController
- (id)init
{
    self = [super init];
    if (self) {
        [self setTabBarItemTitle:@"专题" imageName:@"tabbar_subject" selectedImageName:@"tabbar_subject_press"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor purpleColor];
    //[self.tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCYCELL_ID];
    
    //注册xib
    [self.tabView registerNib:[UINib nibWithNibName:kCYSUBJECT_CELL bundle:nil] forCellReuseIdentifier:kCYCELL_ID];
    
    [self setNavigationBarTitle:@"分类" imageName:@"buttonbar_action" pos:LEFT_ITEM action:@selector(leftBtnClick)];
    [self setNavigationBarTitle:@"设置" imageName:@"buttonbar_action" pos:RIGHT_ITEM action:@selector(rightBtnClick)];
    
    [self downLoadWithURL:SUBJECT_URL];
}

-(void)updateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    CYSubjectCell *subCell = (CYSubjectCell *)cell;
    CYSubjectModel *subModel = self.dataArray[indexPath.row];
    subCell.nameLabel.text = subModel.subName;
    [subCell.headImage sd_setImageWithURL:[NSURL URLWithString:subModel.subImage] placeholderImage:[UIImage imageNamed:@"topic_TopicImage_Default"]];
    
    [subCell.descImage sd_setImageWithURL:[NSURL URLWithString:subModel.subDescImage] placeholderImage:[UIImage imageNamed:@"topic_Header"]];
    subCell.desc.text = subModel.subDesc;
    
    for (NSInteger i = 0; i < 4; i++) {
        CYSubView *subView = (CYSubView *)[subCell.contentView viewWithTag:100+i];
        if(subView == nil)
        {
            //cell 复用之后  view 也要复用
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CYSubView" owner:nil options:0];
            subView = views[0];
            subView.tag = 100 + i;
            subView.frame = CGRectMake(130, 35+i*55, 180, 55);
            subView.backgroundColor = [UIColor clearColor];
            
            [subCell.contentView addSubview:subView];
        }
        
        CYSubAppModel *subAppModel = subModel.subArray[i];
        
        subView.nameLabel.text = subAppModel.subAppName;
        [subView.headImage sd_setImageWithURL:[NSURL URLWithString:subAppModel.subAppIconUrl] placeholderImage:[UIImage imageNamed:@"account_candou"]];
        
        subView.comment.text = subAppModel.subAppComment;
        
        subView.downLoadLabel.text = subAppModel.subAppDownLoads;
        
        [subView.starView setStar:[subAppModel.subAppStarOverall floatValue]];
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
