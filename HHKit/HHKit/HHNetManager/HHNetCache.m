//
//  HHNetCache.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/7.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHNetCache.h"

static NSString * const kHHNetCache = @"HHNetCache";
static YYCache *_dataCache;

@implementation HHNetCache

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:kHHNetCache];
}

/**
 缓存网络数据
 
 @param httpData  服务器返回的数据
 @param urlString 请求的 URL 地址
 @param parameters 请求的参数
 */

+ (void)setHttpCache:(id)httpData
           urlString:(NSString *)urlString
          parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithUrlString:urlString parameters:parameters];
    [_dataCache setObject:httpData forKey:cacheKey];
}

/**
 异步缓存网络数据
 
 @param httpData  服务器返回的数据
 @param urlString 请求的 URL 地址
 @param parameters 请求的参数
 @param block 异步回调
 */

+ (void)setHttpCache:(id)httpData
           urlString:(NSString *)urlString
          parameters:(NSDictionary *)parameters
           withBlock:(void (^)(void))block{
    
    NSString *cacheKey = [self cacheKeyWithUrlString:urlString parameters:parameters];
    [_dataCache setObject:httpData forKey:cacheKey withBlock:^{
        block();
    }];
    
}

/**
 取出缓存数据
 
 @param urlString 请求的 URL 地址
 @param parameters 请求的参数
 @return 缓存的服务器数据
 */
+ (id)httpCacheWithUrlString:(NSString *)urlString
                  parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithUrlString:urlString parameters:parameters];
   return [_dataCache objectForKey:cacheKey];
}

/**
  异步取出缓存数据
  
  @param urlString 请求的 URL 地址
  @param parameters 请求的参数
  @param block 异步回调缓存的数据
 */
+ (void)httpCacheWithUrlString:(NSString *)urlString
                    parameters:(NSDictionary *)parameters
                         block:(void(^)(id <NSCoding> responseObject))block {
    NSString *cacheKey = [self cacheKeyWithUrlString:urlString parameters:parameters];
    [_dataCache objectForKey:cacheKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            block(object);
        });
    }];
}


/**
 @return 缓存数据的大小 (以M为单位)
 */
+ (CGFloat)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost]/1024.0/1024.0;
}

/**
   异步缓存数据的大小 (以M为单位)
 */
+ (void)getAllHttpCacheSizetWithBlock:(void(^)(CGFloat totalCost))block {
    [_dataCache.diskCache totalCostWithBlock:^(NSInteger totalCost) {
        block(totalCost/1024.0/1024.0);
    }];
}


/**
 清空缓存
 */
+ (void)clearAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}

/**
 异步清空缓存
*/
+ (void)clearAllHttpCacheWithBlock:(void(^)(void))block {
    [_dataCache.diskCache removeAllObjectsWithBlock:^{
        block();
    }];
}


// MARK: - Private Methods
+ (NSString *)cacheKeyWithUrlString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters {
    if (!parameters) {
        return urlString;
    }
    
    NSString *prefix = [urlString md5String];
    NSString *suffix = [[parameters jsonStringEncoded] md5String];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",prefix,suffix];
    return cacheKey;
    
}
@end
