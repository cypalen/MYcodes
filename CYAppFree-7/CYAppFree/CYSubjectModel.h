//
//  CYSubjectModel.h
//  CYAppFree
//
//  Created by lcy on 15/6/2.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYSubjectModel : NSObject
@property (nonatomic,strong) NSString *subName;
@property (nonatomic,strong) NSString *subImage;
@property (nonatomic,strong) NSString *subDescImage;
@property (nonatomic,strong) NSString *subDesc;
@property (nonatomic,strong) NSMutableArray *subArray;
-(id)initWithDic:(NSDictionary *)dic;
@end
