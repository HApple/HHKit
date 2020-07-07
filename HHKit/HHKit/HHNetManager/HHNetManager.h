//
//  HHNetManager.h
//  HHKit
//
//  Created by Jn.Huang on 2020/4/6.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHNetwrokStatus) {
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
typedef void(^HHNetworkStatusBlock)(HHNetwrokStatus status);

/*! 定义请求成功的 block*/
typedef void(^HHResponseSuccessBlock)(id response);
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

/**
 网络请求的实例方法 GET
 
 @param enity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度回调
 @return
 */
//+ (NSURLSessionTask *)request
@end

NS_ASSUME_NONNULL_END
