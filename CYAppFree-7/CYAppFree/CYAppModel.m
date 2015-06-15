//
//  CYAppModel.m
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYAppModel.h"

@implementation CYAppModel

-(id)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.appID = dict[@"applicationId"];
        self.appName = dict[@"name"];
        self.appImage = dict[@"iconUrl"];
        self.appPrice = dict[@"lastPrice"];
        self.appShares = dict[@"shares"];
        self.appFavorites = dict[@"favorites"];
        self.appExpireDatetime = dict[@"expireDatetime"];
        self.appDownLoads = dict[@"downloads"];
        self.appCategoryName = dict[@"categoryName"];
        self.appStarCurrent = dict[@"starCurrent"];
        
        self.appFileSize = dict[@"fileSize"];
        self.appDescription = dict[@"description"];
    }
    return self;
}

@end
