//
//  CYDataBase.h
//  CYAppFree
//
//  Created by lcy on 15/6/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYAppModel.h"
@interface CYDataBase : NSObject

+(CYDataBase *)sharedDataBase;
-(void)insertModel:(CYAppModel *)model;
-(BOOL)isExist:(NSString *)appID;
-(NSMutableArray *)getStoreModel;
-(void)deleteModel:(NSString *)appID;
@end
