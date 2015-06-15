//
//  CYHttpRequest.h
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(NSURLResponse *response,id dataObj);
typedef void (^failureBlock)(NSURLResponse *response,NSError *error);
typedef void (^downLoadProgress)(NSInteger readBytes,long long totalReadBytes,long long totalBytes);

@interface CYHttpRequest : NSObject
{
    NSURLConnection *_conn;
}
@property (nonatomic,strong) NSMutableData *downLoad;

+(CYHttpRequest *)sharedManager;

-(void)httpRequestWithURL:(NSString *)urlStr success:(successBlock)success failure:(failureBlock)failure;
-(void)setDownLoadProgress:(downLoadProgress)down;

@end
