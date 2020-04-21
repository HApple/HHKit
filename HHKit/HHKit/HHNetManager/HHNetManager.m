//
//  HHNetManager.m
//  HHKit
//
//  Created by Jn.Huang on 2020/4/6.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHNetManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "HHNetCache.h"
#import "HHDataEntity.h"


static HHNetManager *shareNetManager = nil;

@interface HHNetManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableArray<NSURLSessionTask *> *tasks;

@end

@implementation HHNetManager
/*!
 * 获得全局唯一的网络请求实例单例方法
 *
 * @return 网络请求类单例 HHNetManager
 */
+ (instancetype)sharedHHNetManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetManager = [[HHNetManager alloc] init];
    });
    return shareNetManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupHHNetManager];
    }
    return self;
}

- (void)setupHHNetManager {
    
    /*! 创建一个sessionManager 不用单例 */
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    
    /*! 设置请求超时时间，默认：30秒 */
    self.timeoutInterval = 30;
    
    /*! 打开状态栏的等待菊花 */
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    /*! 设置请求服务器数据类型式为 json */
    self.requestSerializer = HHRequestSerializerJSON;
    
    /*! 设置服务器返回数据类型式为 json */
    self.responseSerializer = HHResponseSerializerJSON;
    
    /*! 设置请求头 ------如应用中的token------*/
    //[self.sessionManager.requestSerializer setValue:@"token" forHTTPHeaderField:@"C7B9126DEEA176DF2994E2B972EF69D8"];
    
    /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
    //[self.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    /*! 设置响应数据的基本类型*/
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain",@"application/javascript",@"application/x-www-form-urlencoded",@"image/*",nil];
    
    /*! 配置自建证书的https请求*/
    [self setupSecurityPolicy];
}

/**
 配置自建证书的https请求,只需要将CA证书文件放入根目录就行
 */
- (void)setupSecurityPolicy {
    
    NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    
    if (cerSet.count == 0) {
        /*!
         如果服务端使用的是正规CA签发的证书 采用默认的defaultPolicy就可以了
         AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务器返回的证书是否是经过正规签名.
         */
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        self.sessionManager.securityPolicy = securityPolicy;
        
    } else {
        /*! 自定义的CA证书配置如下*/
        /*! 自定义security policy, 先确保你的自定义CA证书已放入工程Bundle*/
        /*!
         https://api.github.com 网址的证书实际上是正规 CADigiCert 签发的,
         这里把 Charles 的 CA 根证书导入系统并设为信任后,把 Charles 设为该网址的 SSL Proxy(相当于中间人),
         这样通过代理访问 服务器返回将是由 Charles 伪 CA 签发的证书
         */
        
        // 使用证书验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        // 如果需要验证自建证书(无效证书),需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        // 是否需要验证域名, 默认为YES
        securityPolicy.validatesDomainName = NO;
        
        self.sessionManager.securityPolicy = securityPolicy;
        
    }
}


//MARK: - 网络请求的类方法  GET / POST / PUT / DELETE
/*!
 *  网络请求的实例方法
 *
 *  @param type          get / post / put / delete
 *  @param isNeedCache   是否需要缓存，只有 get / post 请求有缓存配置
 *  @param urlString     请求的地址
 *  @param parameters    请求的参数
 *  @param headers       请求头 在默认请求头的基础上再增加自定义的
 *  @param progressBlock 进度
 *  @param successBlock  请求成功的回调
 *  @param failureBlock  请求失败的回调
 
 */
- (NSURLSessionTask *)requestWithType:(HHRequstType)type
                          isNeedCache:(BOOL)isNeedCache
                            urlString:(NSString *)urlString
                           parameters:(id)parameters
                              headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                        progressBlock:(HHDownloadProgressBlock)progressBlock
                         successBlock:(HHResponseSuccessBlock)successBlock
                         failureBlock:(HHResponseFailBlock)failureBlock {
    
    if (urlString == nil) {
        return nil;
    }
    
    /*! 检查地址中是否有中文*/
    NSString *URLString = [NSURL URLWithString:urlString] ? urlString : [urlString hh_UTF8_Encoding];
    
    NSString *requestType;
    switch (type) {
        case HHRequestTypeGet:
            requestType = @"GET";
            break;
        case HHRequestTypePost:
            requestType = @"POST";
            break;
        case HHRequestTypePut:
            requestType = @"PUT";
            break;
        case HHRequestTypeDelete:
            requestType = @"DELETE";
            break;
        default:
            break;
    }

#if DEBUG
    if (self.isOpenLog) {
        NSString *isCache = isNeedCache ? @"开启":@"关闭";
        HHLog(@"\n******************** 请求参数 ***************************");
        HHLog(@"\n 缓存: %@\n",isCache);
        HHLog(@"\n requestType: %@\n",isCache);
        HHLog(@"\n request: %@\n",self.sessionManager.requestSerializer);
        HHLog(@"\n response: %@\n",self.sessionManager.responseSerializer);
        HHLog(@"\n timeOut: %f\n",self.timeoutInterval);
        HHLog(@"\n httpheader: %@\n",self.sessionManager.requestSerializer.HTTPRequestHeaders);
        HHLog(@"\n********************************************************");
    }
#endif
    
    NSURLSessionTask *sessionTask = nil;
    
    if (isNeedCache) {
        // 读取缓存
        id responseCacheData = [HHNetCache httpCacheWithUrlString:urlString parameters:parameters];
        if (responseCacheData != nil) {
            if (successBlock) {
                successBlock(responseCacheData,YES);
            }
        }
        if (self.isOpenLog) {
            HHLog(@"取用缓存数据结果： *** %@", responseCacheData);
        }
    }
    
    if (self.isSetQueryStringSerialization) {
        [self.sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError *__autoreleasing  _Nullable * _Nullable error) {
            return parameters;
        }];
    }
    
    if (type == HHRequestTypeGet) {
        sessionTask = [self.sessionManager GET:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
            if (self.isOpenLog)
            {
                HHLog(@"下载进度--%lld, 总进度---%lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            }
            /*! 回到主线程刷新UI */
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock)
                {
                    progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                }
            });
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (self.isOpenLog) {
                HHLog(@"get 请求数据结果： *** %@", responseObject);
            }
            
            if (successBlock) {
                successBlock(responseObject,NO);
            }
            
            //对数据进行异步缓存
            if (isNeedCache) {
                [HHNetCache setHttpCache:responseObject urlString:urlString parameters:parameters withBlock:^{
                    HHLog(@"urlString - %@, parameters - %@, 结果缓存成功",urlString,parameters);
                }];
            }
            
            [self.tasks removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (self.isOpenLog) {
                HHLog(@"错误信息：%@",error);
            }
            
            if (failureBlock) {
                failureBlock(error);
            }
            [self.tasks removeObject:sessionTask];
            
        }];
        
    }else if(type == HHRequestTypePost) {
        
        sessionTask = [self.sessionManager POST:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
            
            if (self.isOpenLog){
                HHLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            }
            
            /*! 回到主线程刷新UI */
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock)
                {
                    progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                }
            });

            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (self.isOpenLog) {
                HHLog(@"post 请求数据结果： *** %@", responseObject);
            }
            
            if (successBlock){
                successBlock(responseObject,NO);
            }
            
            //对数据进行异步缓存
            if (isNeedCache) {
                [HHNetCache setHttpCache:responseObject urlString:urlString parameters:parameters withBlock:^{
                    HHLog(@"urlString - %@, parameters - %@, 结果缓存成功",urlString,parameters);
                }];
            }
            
            [self.tasks removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (self.isOpenLog) {
                HHLog(@"错误信息：%@",error);
            }
            
            if (failureBlock) {
                failureBlock(error);
            }
            [self.tasks removeObject:sessionTask];
            
        }];
        
    }else if (type == HHRequestTypePut) {
        
        sessionTask = [self.sessionManager PUT:URLString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock) {
                successBlock(responseObject,NO);
            }
            [self.tasks removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            if (self.isOpenLog) {
                HHLog(@"错误信息：%@",error);
            }
            
            if (failureBlock) {
                failureBlock(error);
            }
            [self.tasks removeObject:sessionTask];
        }];
        
    }else if(type == HHRequestTypeDelete) {
        
        sessionTask = [self.sessionManager DELETE:URLString parameters:parameters headers:headers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject,NO);
            }
            [self.tasks removeObject:sessionTask];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            if (self.isOpenLog) {
                HHLog(@"错误信息：%@",error);
            }
            
            if (failureBlock) {
                failureBlock(error);
            }
            [self.tasks removeObject:sessionTask];
            
        }];
    }
    
    if (sessionTask) {
        [self.tasks addObject:sessionTask];
    }
    
    return sessionTask;
}


/**
 网络请求的实例方法 GET
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestGetWithEnity:(HHDataEntity *)entity
                            progerssBlock:(HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                             failureBlock:(HHResponseFailBlock)failureBlock {
    
    if (!entity || ![entity isKindOfClass:[HHDataEntity class]]) {
        return nil;
    }
    return [self requestWithType:HHRequestTypeGet isNeedCache:entity.isNeedCache urlString:entity.urlString parameters:entity.parameters headers:entity.headers progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
    
}


/**
 网络请求的实例方法 POST
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestPostWithEnity:(HHDataEntity *)entity
                            progerssBlock:(HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                              failureBlock:(HHResponseFailBlock)failureBlock {
    if (!entity || ![entity isKindOfClass:[HHDataEntity class]]) {
        return nil;
    }
    return [self requestWithType:HHRequestTypePost isNeedCache:entity.isNeedCache urlString:entity.urlString parameters:entity.parameters headers:entity.headers progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}


/**
 网络请求的实例方法 PUT
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestPutWithEnity:(HHDataEntity *)entity
                            progerssBLock:(HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                             failureBlock:(HHResponseFailBlock)failureBlock {
    if (!entity || ![entity isKindOfClass:[HHDataEntity class]]) {
        return nil;
    }
    return [self requestWithType:HHRequestTypePut isNeedCache:NO urlString:entity.urlString parameters:entity.parameters headers:entity.headers progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}

/**
 网络请求的实例方法 DELETE
 
 @param entity 请求信息载体
 @param progressBlock 进度回调
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestDeleteWithEnity:(HHDataEntity *)entity
                            progerssBlock:(HHDownloadProgressBlock)progressBlock
                             successBlock:(HHResponseSuccessBlock)successBlock
                                failureBlock:(HHResponseFailBlock)failureBlock {
    if (!entity || ![entity isKindOfClass:[HHDataEntity class]]) {
        return nil;
    }
    return [self requestWithType:HHRequestTypeDelete isNeedCache:NO urlString:entity.urlString parameters:entity.parameters headers:entity.headers progressBlock:progressBlock successBlock:successBlock failureBlock:failureBlock];
}


/**
 上传图片（多图）
 
 @param entity 请求信息载体
 @param progressBlock 上传进度
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)uploadImageWithEntity:(HHImageDataEntiy *)entity
                              progressBlock:(HHUploadProgressBlock)progressBlock
                               successBlock:(HHResponseSuccessBlock)successBlock
                               failureBlock:(HHResponseFailBlock)failureBlock {
    
    if (!entity || ![entity isKindOfClass:[HHImageDataEntiy class]]) {
        return nil;
    }
    
    
    
    
}


/**
 视频上传
 
 @param entity 请求信息载体
 @param progressBlock 上传进度
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 */
- (void)uploadVideoWithEntity:(HHDataEntity *)entity
                progressBlock:(HHUploadProgressBlock)progressBlock
                 successBlock:(HHResponseSuccessBlock)successBlock
                 failureBlock:(HHResponseFailBlock)failureBlock {
    
}


/**
 文件上传
 
 @param entity 请求信息载体
 @param progressBlock 上传进度
 @param successBlock 上传成功的回调
 @param failureBlock 上传失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)uploadFileWithEntity:(HHDataEntity *)entity
                             progressBlock:(HHUploadProgressBlock)progressBlock
                              successBlock:(HHResponseSuccessBlock)successBlock
                              failureBlock:(HHResponseFailBlock)failureBlock {
    
}


/**
 文件下载
 
 @param entity 请求信息载体
 @param progressBlock 下载进度
 @param successBlock 下载成功的回调
 @param failureBlock 下载失败的回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)downloadFileWithEntity:(HHDataEntity *)entity
                               progressBlock:(HHDownloadProgressBlock)progressBlock
                                successBlock:(HHResponseSuccessBlock)successBlock
                                failureBlock:(HHResponseFailBlock)failureBlock {
    
}


// MARK: - 取消 HTTP 请求
/*！
 * 取消所有 HTTP 请求
 */
- (void)cancelAllRequest {
    
    // 锁操作
    @synchronized (self) {
        [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj cancel];
        }];
        [self.tasks removeAllObjects];
    }
    
}

/*!
 * 取消指定 URL的 HTTP 请求
 */
- (void)cancelRequestWithURL:(NSString *)URL {
    
}

// MARK: - setter / getter
/**
 存储着所有请求的task数组
 
 @return 存储着所有请求的task数组
 */
- (NSMutableArray<NSURLSessionTask *> *)tasks {
    if (!_tasks) {
        _tasks = [[NSMutableArray alloc] init];
    }
    return _tasks;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
    self.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setRequestSerializer:(HHRequestSerializer)requestSerializer {
    _requestSerializer = requestSerializer;
    switch (requestSerializer) {
        case HHRequestSerializerJSON:
        {
            self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        case HHRequestSerializerHTTP:
        {
            self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
             
        }
        default:
            break;
    }
}

- (void)setResponseSerializer:(HHResponseSerializer)responseSerializer {
    _responseSerializer = responseSerializer;
    switch (responseSerializer) {
        case HHResponseSerializerJSON:
            self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case HHResponseSerializerHTTP:
            self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
}

- (void)setHttpHeaderFieldDictionary:(NSDictionary *)httpHeaderFieldDictionary {
    _httpHeaderFieldDictionary = httpHeaderFieldDictionary;
    if (![httpHeaderFieldDictionary isKindOfClass:[NSDictionary class]]) {
        HHLog(@"请求头数据有误，请检查！");
        return;
    }
    NSArray *keyArray = httpHeaderFieldDictionary.allKeys;
    if (keyArray.count <= 0) {
        HHLog(@"请求头数据有误，请检查！");
        return;
    }
    
    for (NSInteger i = 0; i < keyArray.count; i++) {
        NSString *keyString = keyArray[i];
        NSString *valueString = httpHeaderFieldDictionary[keyString];
        [self.sessionManager.requestSerializer setValue:valueString forHTTPHeaderField:keyString];
    }
}

// MARK: - 自定义请求头
- (void)setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey {
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderKey];
}

// MARK: - 删除所有请求头
- (void)clearAuthorizationHeader {
    [self.sessionManager.requestSerializer clearAuthorizationHeader];
}

/*!
 * 清空缓存： 此方法可能会阻塞调用线程 直到文件删除完成
 */
+ (void)clearAllHttpCache:(void(^)(void))block {
    
    [HHNetCache clearAllHttpCacheWithBlock:block];
}

// MARK: - 网络状态检测
/*!
 *  开启实时网络状态监测， 通过Block回调实时获取（此方法可多次调用）
 */
+ (void)startNetWorkMonitoringWithBlock:(HHNetworkStatusBlock)networkStatus {
    /*! 1.获得网络监控的管理者 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*! 当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 2.设置网络状态改变后的处理 */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*! 当网络状态改变了, 就会调用这个block */
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                HHLog(@"未知网络");
                networkStatus ? networkStatus(HHNetworkStatusUnknown) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                HHLog(@"没有网络");
                networkStatus ? networkStatus(HHNetworkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                HHLog(@"手机自带网络");
                networkStatus ? networkStatus(HHNetworkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                HHLog(@"wifi 网络");
                networkStatus ? networkStatus(HHNetworkStatusReachableViaWiFi) : nil;
                break;
        }
    }];
    [manager startMonitoring];
    
}

@end


// MARK: - NSDictionary, NSArray的分类
/*
 新建 NSDictionary 与 NSArray 的分类, 控制台打印 JSON 数据中的中文
 */
#ifdef DEBUG
@implementation NSArray (HHNetManager)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"\t%@,\n",obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end


@implementation NSDictionary (HHNetManager)

- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}"];
    
    return strM;
}

@end

#endif

