//
//  CYHttpRequest.m
//  CYAppFree
//
//  Created by lcy on 15/6/1.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CYHttpRequest.h"

@interface CYHttpRequest () <NSURLConnectionDataDelegate>

@end

@implementation CYHttpRequest
{
    successBlock _success;
    failureBlock _failure;
    downLoadProgress _down;
    NSURLResponse *_response;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.downLoad = [[NSMutableData alloc] init];
    }
    return self;
}
-(void)setDownLoadProgress:(downLoadProgress)down
{
    _down = down;
}

+(CYHttpRequest *)sharedManager
{
    CYHttpRequest *requset = [[CYHttpRequest alloc] init];
    
    return requset;
}

-(void)httpRequestWithURL:(NSString *)urlStr success:(successBlock)success failure:(failureBlock)failure
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    _conn = [[NSURLConnection alloc] initWithRequest:requset delegate:self];
    _success = success;
    _failure = failure;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(_failure != nil)
    {
        _failure(_response,error);
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downLoad appendData:data];
    if(_down != nil)
    {
        _down(data.length,self.downLoad.length,_response.expectedContentLength);
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.downLoad.length = 0;
    _response = response;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_success != nil)
    {
        _success(_response,self.downLoad);
    }
}

@end
