//
//  CYSubjectModel.m
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYSubjectModel.h"
#import "CYSubAppModel.h"

@implementation CYSubjectModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.subName = dic[@"title"];
        self.subImage = dic[@"img"];
        self.subDescImage = dic[@"desc_img"];
        self.subDesc = dic[@"desc"];
        
        NSArray *arr = dic[@"applications"];
        self.subArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in arr) {
            CYSubAppModel *subModel = [[CYSubAppModel alloc] initWithDic:dict];
            
            [self.subArray addObject:subModel];
        }
    }
    return self;
}

@end
