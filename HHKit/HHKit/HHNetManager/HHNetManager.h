//
//  HHNetManager.h
//  HHKit
//
//  Created by Jn.Huang on 2020/4/6.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HHKitMacro.h"
#import "NSString+HHUtilities.h"
#import "HHNetCache.h"
#import "HHDataEntity.h"

#define HHNetManagerShared [HHNetManager sharedHHNetManager]

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHNetworkStatus) {
    /*! 未知网络*/
    HHNetworkStatusUnknown              =  0,
    /*! 没有网络*/
    HHNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络*/
    HHNetworkStatusReachableViaWWAN,
    /*! WiFi 网络*/
    HHNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, HHRequstType) {
    
    /*! get请求 */
    HHRequestTypeGet = 0,
    /*! post请求 */
    HHRequestTypePost,
    /*! put请求 */
    HHRequestTypePut,
    /*! delete请求 */
    HHRequestTypeDelete
};

typedef NS_ENUM(NSUInteger, HHRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    HHRequestSerializerJSON,
    /** 设置请求数据为HTTP格式*/
    HHRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, HHResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    HHResponseSerializerJSON,
    /** 设置响应数据为HTTP格式*/
    HHResponseSerializerHTTP,
};


/*! 实时监测网络状态的 block*/
typedef void(^HHNetworkStatusBlock)(HHNetworkStatus status);

/*! 定义请求成功的 block*/
typedef void(^HHResponseSuccessBlock)(id response, BOOL isCache);
/*! 定义请求失败的 block*/
typedef void(^HHResponseFailBlock)(NSError *error);

/*! 定义上传进度 block*/
typedef void(^HHUploadProgressBlock)(int64_t bytesProgress, int64_t totalBytesProgress);
/*! 定义下载进度 block*/
typedef void(^HHDownloadProgressBlock)(int64_t bytesProgress, int64_t totalBytesProgress);


@class HHDataEntity;

@interface HHNetManager : NSObject

/**
 创建的请求的超时间隔（以秒为单位），此设置为全局统一设置一次即可，默认超时时间间隔为30秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 设置网络请求参数的格式，此设置为全局统一设置一次即可，默认：HHRequestSerializerJSON
 */
@property (nonatomic, assign) HHRequestSerializer requestSerializer;

/**
 设置服务器响应数据格式，此设置为全局统一设置一次即可，默认：HHResponseSerializerJSON
 */
@property (nonatomic, assign) HHResponseSerializer responseSerializer;

/**
 自定义请求头
 */
@property (nonatomic, strong) NSDictionary *httpHeaderFieldDictionary;

/**
 将传入的 string 参数序列化
 */
@property (nonatomic, assign) BOOL isSetQueryStringSerialization;

/**
 是否开启 log 打印 默认不开启
 */
@property (nonatomic, assign) BOOL isOpenLog;

/*!
 * 获得全局唯一的网络请求实例单例方法
 *
 * @return 网络请求类单例 HHNetManager
 */
+ (instancetype)sharedHHNetManager;

//MARK: - 网络请求的类方法  GET / POST / PUT / DELETE
/*!
 *  网络请求的实例方法
 *
 *  @param type         get / post / put / delete
 *  @param isNeedCache  是否需要缓存，只有 get / post 请求有缓存配置
 *  @param urlString    请求的地址
 *  @param parameters    请求的参数
 *  @param headers       请求头 在默认请求头的基础上再增加自定义的
 *  @param progressBlock 进度
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  x
 */
- (NSURLSessionTask *)requestWithType:(HHRequstType)type
                             isNeedCache:(BOOL)isNeedCache
                               urlString:(NSString *)urlString
                              parameters:(id)parameters
                                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                           progressBlock:(nullable HHDownloadProgressBlock)progressBlock
                            successBlock:(HHResponseSuccessBlock)successBlock
                            failureBlock:(HHResponseFailBlock)failureBlock;

/**
 网络请求的实例方法 GET
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestGetWithEnity:(HHDataEntity *)entity
                            progerssBlock:(nullable HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                             failureBlock:(HHResponseFailBlock)failureBlock;


/**
 网络请求的实例方法 POST
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestPostWithEnity:(HHDataEntity *)entity
                            progerssBlock:(nullable HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                             failureBlock:(HHResponseFailBlock)failureBlock;


/**
 网络请求的实例方法 PUT
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestPutWithEnity:(HHDataEntity *)entity
                            progerssBlock:(nullable HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                             failureBlock:(HHResponseFailBlock)failureBlock;

/**
 网络请求的实例方法 DELETE
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestDeleteWithEnity:(HHDataEntity *)entity
                            progerssBlock:(nullable HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                             failureBlock:(HHResponseFailBlock)failureBlock;


/**
 上传图片（多图）
 
 @param entity 请求信息载体
 @param progressBlock 上传进度
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)uploadImageWithEntity:(HHImageDataEntity *)entity
                              progressBlock:(nullable HHUploadProgressBlock)progressBlock
                               successBlock:(HHResponseSuccessBlock)successBlock
                               failureBlock:(HHResponseFailBlock)failureBlock;


/**
 视频上传
 
 @param entity 请求信息载体
 @param progressBlock 上传进度
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 */
- (void)uploadVideoWithEntity:(HHFileDataEntity *)entity
                progressBlock:(nullable HHUploadProgressBlock)progressBlock
                 successBlock:(HHResponseSuccessBlock)successBlock
                 failureBlock:(HHResponseFailBlock)failureBlock;


/**
 文件上传
 
 @param entity 请求信息载体
 @param progressBlock 上传进度
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)uploadFileWithEntity:(HHFileDataEntity *)entity
                progressBlock:(nullable HHUploadProgressBlock)progressBlock
                 successBlock:(HHResponseSuccessBlock)successBlock
                 failureBlock:(HHResponseFailBlock)failureBlock;


/**
 文件下载
 
 @param entity 请求信息载体
 @param progressBlock 下载进度
 @param successBlock 下载成功的回调
 @param failureBlock 下载失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)downloadFileWithEntity:(HHFileDataEntity *)entity
                progressBlock:(nullable HHDownloadProgressBlock)progressBlock
                 successBlock:(HHResponseSuccessBlock)successBlock
                 failureBlock:(HHResponseFailBlock)failureBlock;



// MARK: - 网络状态检测
/*!
 *  开启实时网络状态监测， 通过Block回调实时获取（此方法可多次调用）
 */
+ (void)startNetWorkMonitoringWithBlock:(HHNetworkStatusBlock)networkStatus;


// MARK: - 自定义请求头
- (void)setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;

// MARK: - 删除所有请求头
- (void)clearAuthorizationHeader;

// MARK: - 取消 HTTP 请求
/*！
 * 取消所有 HTTP 请求
 */
- (void)cancelAllRequest;

/*!
 * 取消指定 URL的 HTTP 请求
 */
- (void)cancelRequestWithURL:(NSString *)URL;


// MARK: - 异步清空缓存
+ (void)clearAllHttpCache:(nullable void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
