//
//  HttpRequestManager.m
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/15.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import "HttpRequestManager.h"
#import "NetInterface.h"
#import "AFNetworking.h"
@implementation HttpRequestManager
+ (instancetype)shareInstance
{
    static HttpRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpRequestManager alloc]init];
    });
    return manager;
}

- (void)getMainInfoWithPage:(int)page AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:kMain_Url,page,nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        success(self,array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败的回调
        failure(self,error);
    }];
}
//请求农历,宜和忌信息
- (void)getFitAndAvoidInfoWithYear:(NSString *)year AndMonth:(NSString *)month AndDay:(NSString *)day AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:kMainDate_Url,year,month,day];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        NSDictionary *dic2 = array[0];
        success(self,dic2);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}
//请求菜品详情
- (void)getFoodDetailWithID:(NSString *)ID AndType:(int)type AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:CAILIAO_URL,ID,type];
    NSLog(@"url==%@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        success(self,array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

//智能选菜搜索
- (void)smartSearchByID:(NSString *)ID AndPage:(int)page AndPageRecord:(int)pageRecord AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:SMART_SEARCH_URL,ID,page,pageRecord];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        success(self,array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failure(self,error);
    }];
}
//搜索
- (void)searchByName:(NSString *)name AndChineseName:(NSString *)chineseName AndTaste:(NSString *)taste AndCrowd:(NSString *)crowd AndMethod:(NSString *)method AndEffect:(NSString *)effect AndPage:(int)page AndPageRecord:(int)pageRecord AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure
{
    NSString *url = [NSString stringWithFormat:SEARCH_URL,name,chineseName,taste,crowd,method,effect,page,pageRecord];
    NSLog(@"url==%@",url);
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        success(self,array);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
    }];
}
@end
