//
//  CYAppModel.h
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYAppModel : NSObject

@property (nonatomic,strong) NSString *appFileSize;
@property (nonatomic,strong) NSString *appDescription;
@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSString *appName;
@property (nonatomic,strong) NSString *appImage;
@property (nonatomic,strong) NSString *appDownLoads;
@property (nonatomic,strong) NSString *appFavorites;
@property (nonatomic,strong) NSString *appStarCurrent;
@property (nonatomic,strong) NSString *appExpireDatetime;
@property (nonatomic,strong) NSString *appShares;
@property (nonatomic,strong) NSString *appPrice;
@property (nonatomic,strong) NSString *appCategoryName;

-(id)initWithDic:(NSDictionary *)dict;
@end
