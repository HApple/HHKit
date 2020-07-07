//
//  HHNetCache.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/7.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <YYKit/YYKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HHNetCache : NSObject

/**
 缓存网络数据
 
 @param httpData  服务器返回的数据
 @param urlString 请求的 URL 地址
 @param parameters 请求的参数
 */

+ (void)setHttpCache:(id)httpData
           urlString:(NSString *)urlString
          parameters:(NSDictionary *)parameters;

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
           withBlock:(void (^)(void))block;


/**
 取出缓存数据
 
 @param urlString 请求的 URL 地址
 @param parameters 请求的参数
 @return 缓存的服务器数据
 */
+ (id)httpCacheWithUrlString:(NSString *)urlString
                  parameters:(NSDictionary *)parameters;

/**
  异步取出缓存数据
  
  @param urlString 请求的 URL 地址
  @param parameters 请求的参数
  @param block 异步回调缓存的数据
 */
+ (void)httpCacheWithUrlString:(NSString *)urlString
                    parameters:(NSDictionary *)parameters
                         block:(void(^)(id <NSCoding> responseObject))block;


/**
 @return 缓存数据的大小 (以M为单位)
 */
+ (CGFloat)getAllHttpCacheSize;

/**
   异步缓存数据的大小 (以M为单位)
 */
+ (void)getAllHttpCacheSizetWithBlock:(void(^)(CGFloat totalCost))block;

/**
 清空缓存
 */
+ (void)clearAllHttpCache;

/**
 异步清空缓存
*/
+ (void)clearAllHttpCacheWithBlock:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
