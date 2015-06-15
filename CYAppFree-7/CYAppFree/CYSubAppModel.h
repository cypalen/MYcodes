//
//  CYSubAppModel.h
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYSubAppModel : NSObject

@property (nonatomic,strong) NSString *subAppName;
@property (nonatomic,strong) NSString *subAppIconUrl;
@property (nonatomic,strong) NSString *subAppStarOverall;
@property (nonatomic,strong) NSString *subAppDownLoads;
@property (nonatomic,strong) NSString *subAppComment;

-(id)initWithDic:(NSDictionary *)dic;

@end
