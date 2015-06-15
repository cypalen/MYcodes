//
//  CYSubAppModel.m
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYSubAppModel.h"

@implementation CYSubAppModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.subAppName = dic[@"name"];
        self.subAppIconUrl = dic[@"iconUrl"];
        self.subAppStarOverall = dic[@"starOverall"];
        self.subAppDownLoads = dic[@"downloads"];
        self.subAppComment = [NSString stringWithFormat:@"%@",dic[@"comment"]];
    }
    return self;
}

@end
