//
//  SCNetwork.h
//  SCNetworking
//
//  Created by 孙程 on 16/5/25.
//  Copyright © 2016年 Suncheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(NSDictionary *dic);
typedef void (^FailureBlock)(NSError *error);

@interface SCNetwork : NSObject <NSURLSessionDelegate>

+ (instancetype)sharedSCNetwork;

/**
 *  网络请求（GET/POST）
 *
 *  @param url             URL
 *  @param params          参数
 *  @param completionBlock 成功回调
 *  @param failureBlock    失败回调
 */

- (void)get:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(NSDictionary *responseData))completionBlock failureBlock:(void(^)(NSError *error))failureBlock;

- (void)post:(NSString *)url params:(NSDictionary *)params completionBlock:(void(^)(NSDictionary *responseData))completionBlock failureBlock:(void(^)(NSError *error))failureBlock;


#pragma mark ========= 示例 （V3EX的接口）

- (void)requestV2withParam:(NSDictionary *)dic completionBlock:(SuccessBlock)succeed failureBlock:(FailureBlock)failure;

@end
