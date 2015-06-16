//
//  HttpRequestManager.h
//  PockerKitchen
//
//  Created by liuyuecheng on 15/6/15.
//  Copyright (c) 2015年 liuyuecheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//在类声明之前使用它,需要告诉编译器,会在后面实现
@class HttpRequestManager;
//成功的回调
typedef void (^httpRequestSuccess)(HttpRequestManager *manager,id object);
//失败的回调
typedef void (^httpRequestFailure) (HttpRequestManager *manager,NSError *error);

@interface HttpRequestManager : NSObject
//将数据请求类做成单例,因为在很多个页面都要进行数据请求
+ (instancetype)shareInstance;

//请求主页的数据
- (void)getMainInfoWithPage:(int)page AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure;

//请求农历,宜和忌信息
- (void)getFitAndAvoidInfoWithYear:(NSString *)year AndMonth:(NSString *)month AndDay:(NSString *)day AndCompletionSuccess:(httpRequestSuccess)success AndFailure:(httpRequestFailure)failure;
@end
