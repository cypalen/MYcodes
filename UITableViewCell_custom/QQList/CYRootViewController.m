//
//  CYRootViewController.m
//  QQList
//
//  Created by lcy on 15/5/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYRootViewController.h"
#import "CYStudent.h"
#import "CYStudentCell.h"
#import "CYThreeImageCell.h"

@interface CYRootViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tabView;
@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation CYRootViewController

/*
    student  Model
    10   name    age   gender
 */

-(UITableView *)tabView
{
    if(_tabView == nil)
    {
        _tabView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
    }
    
    return _tabView;
}

//name    age
-(NSMutableArray *)data
{
    if(_data == nil)
    {
        _data = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 20; i++) {
            CYStudent *stu = [[CYStudent alloc] init];
            stu.headImage = @"head.JPG";
            stu.name = [NSString stringWithFormat:@"qianfeng%d",i];
            stu.age = [NSString stringWithFormat:@"%d",arc4random() % 99 + 1];
            
            if(arc4random() % 2 == 0)
            {
                stu.gender = @"男";
            }
            else
            {
                stu.gender = @"女";
            }
            [_data addObject:stu];
        }
    }
    
    return _data;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  UIView
    //自定义cell  ---->  继承UITableViewCell
    //2.增加想要的控件
    //3.使用自己的cell
    if(indexPath.row % 3 == 0)
    {
        CYThreeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if(cell == nil)
        {
            cell = [[CYThreeImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
        }
    
        [cell refreshUI];
        return cell;
    }
    else
    {
        CYStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if(cell == nil)
        {
            cell = [[CYStudentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        CYStudent *stu = self.data[indexPath.row];
        [cell refreshData:stu];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tabView];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tabView setEditing:editing animated:YES];
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
