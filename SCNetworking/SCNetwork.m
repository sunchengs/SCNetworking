//
//  SCNetwork.m
//  SCNetworking
//
//  Created by 孙程 on 16/5/25.
//  Copyright © 2016年 Suncheng. All rights reserved.
//

#import "SCNetwork.h"

@interface SCNetwork ()

@property (copy, nonatomic) NSString *hostName;

@end

@implementation SCNetwork

+ (instancetype)sharedSCNetwork
{
    static SCNetwork *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[SCNetwork alloc] initWithHostName:@"https://www.v2ex.com"];
    });
    return network;
}

- (id)initWithHostName:(NSString *)hostName
{
    if((self = [super init])) {
        if (hostName) {
            self.hostName = hostName;
        }
    }
    return self;
}

- (void)get:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(NSDictionary *responseData))completionBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    [self requestURL:url method:@"GET" params:params completionBlock:completionBlock failureBlock:failureBlock];
}

- (void)post:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(NSDictionary *responseData))completionBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    [self requestURL:url method:@"POST" params:params completionBlock:completionBlock failureBlock:failureBlock];
}

- (void)requestURL:(NSString *)url method:(NSString *)method params:(NSDictionary *)params completionBlock:(void(^)(NSDictionary *responseData)) completionBlock failureBlock:(void(^)(NSError *error))failureBlock
{
    NSString *baseUrl = [NSString stringWithFormat:@"%@/",self.hostName];
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:baseUrl];
    [mutableUrl appendString:url];
    if ([params allKeys]) {
        [mutableUrl appendString:@"?"];
        for (id key in params) {
            NSString *value = [[params objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:urlEnCode];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;
    if ([method isEqualToString:@"POST"]) {
        request.HTTPBody = [mutableUrl dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    //    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      ;
                                      if (error) {
                                          failureBlock(error);
                                      } else {
                                          NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                          completionBlock(dic);
                                      }
                                  }];
    
    [task resume];
}

#pragma mark - NSURLSessionDelegate 代理方法

//主要就是处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}


#pragma mark ========= 示例 （V3EX的接口）

- (void)requestV2withParam:(NSDictionary *)dic completionBlock:(SuccessBlock)succeed failureBlock:(FailureBlock)failure{
    [self get:@"api/topics/show.json" params:dic completionBlock:succeed failureBlock:failure];
}


@end
