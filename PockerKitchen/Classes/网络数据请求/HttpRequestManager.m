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
@end
