//
//  CYDataBase.m
//  CYAppFree
//
//  Created by lcy on 15/6/3.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYDataBase.h"
#import "FMDatabase.h"

@implementation CYDataBase
{
    FMDatabase *_fmDataBase;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"store.db"];
        NSLog(@"%@",path);
        _fmDataBase = [FMDatabase databaseWithPath:path];
        [_fmDataBase open];
        
        NSString *sqlStr = @"create table if not exists store(appID text primary key,appName text,appImage text)";
        [_fmDataBase executeUpdate:sqlStr];
        [_fmDataBase close];
    }
    return self;
}

+(CYDataBase *)sharedDataBase
{
    static CYDataBase *dataBase = nil;
    
    if(dataBase == nil)
    {
        dataBase = [[[self class] alloc] init];
    }
    
    return dataBase;
}

-(BOOL)isExist:(NSString *)appID
{
    BOOL ret = 0;
    [_fmDataBase open];
    NSString *sqlStr = @"select * from store where appID = ?";
    FMResultSet *resultSet = [_fmDataBase executeQuery:sqlStr,appID];
    
    ret = [resultSet next];
    [_fmDataBase close];
    
    return ret;
}

-(void)insertModel:(CYAppModel *)model
{
    [_fmDataBase open];
    NSString *sqlStr = @"insert into store (appID,appName,appImage) values (?,?,?)";
    [_fmDataBase executeUpdate:sqlStr,model.appID,model.appName,model.appImage];
    [_fmDataBase close];
}

-(void)deleteModel:(NSString *)appID
{
    [_fmDataBase open];
    
    NSString *sqlStr = @"delete from store where appID = ?";
    [_fmDataBase executeUpdate:sqlStr,appID];
    
    [_fmDataBase close];
}

-(NSMutableArray *)getStoreModel
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    [_fmDataBase open];
    NSString *sqlStr = @"select * from store";
    FMResultSet *resultSet = [_fmDataBase executeQuery:sqlStr];
    
    while ([resultSet next]) {
        CYAppModel *model = [[CYAppModel alloc] init];
        
        model.appID = [resultSet stringForColumn:@"appID"];
        model.appName = [resultSet stringForColumn:@"appName"];
        model.appImage = [resultSet stringForColumn:@"appImage"];
        
        [modelArray addObject:model];
    }
    [_fmDataBase close];

    return modelArray;
}


@end
