//
//  HHKitMacro.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#ifndef HHKitMacro_h
#define HHKitMacro_h

//MARK: - UI Define
/// IPHONE_X 判断
#define  IS_IPHONE_XSeries  [UIDevice isIphoneXSeries]
/// 状态栏 导航栏 底部高
#define  kSafeAreaInsetsTop       [UIScreen hh_safeAreaInsetsTop]
#define  kSafeAreaInsetsBootom    [UIScreen hh_safeAreaInsetsBottom]
#define  kStatusBarHeight         [UIScreen hh_statusBarHeight]
#define  kNavBarHeight            [UIScreen hh_navBarHeight]
#define  kTabBarHeight            [UIScreen hh_tabbarHeight]
/// 屏幕适配，以IPhone6为基准，375是宽，667是高
#define kFitScreen(x) (x * (kScreenWidth / 375.0))
#define kFontSize(x)  [UIFont systemFontOfSize:kFitScreen(x)]

#ifdef DEBUG
#define HHLog(fmt, ...)   \
NSLog((@"%s\n" fmt),__FUNCTION__, ##__VA_ARGS__);
#else
#define HHLog(...);
#endif

#define HH_WeakSelf     @HH_Weakify(self);
#define HH_StrongSelf   @HH_Strongify(self);

#ifndef HH_Weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define HH_Weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define HH_Weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define HH_Weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define HH_Weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef HH_Strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define HH_Strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define HH_Strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define HH_Strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define HH_Strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

// MARK:- YYKit
/// YYKit 提供了很多便捷用法 无需自己再累赘写了
/*
 @weakify(self)
 [self doSomething^{
     @strongify(self)
     if (!self) return;      -> 处理循环引用
     ...
 }];
 
 NSObject+YYAdd -> Swizzling, Associate value, deep copy
 
 UIFont+YYAdd -> 直接加载TTF,OTF格式字体
 
 YYModel+YYAdd -> 自动转换模型数据
 
 UIImageView+YYWebImage -> 完全替代SDWebImage
 
 NSObject+YYAddForKVO
 UIBarButtonItem+YYAdd    -> 都提供了block action的方式
 UIControl+YYAdd
 UIGestureRecognizer
 
 YYTimer -> 替代 NSTimer 用线程安全基于GCD实现 还避免了NSTimer所引起的循环引用问题
 
 YYTextView -> 替代 UITextView 支持 placeholder
 
 YYReachability ->  检测网路状态
 
 YYThreadSafeArray        -> 线程安全的 NSMutableArray
 YYThreadSafeDictionary   -> 线程安全的 NSMutableDictionary
 
 UIBezierPath+YYAdd -> 生成文字的path
 
 YYImage -> 支持WebP APNG GIF格式 通过 YYAnimatedImageView 展示
 YYFrameImage  -> 通过 YYAnimatedImageView 展示一组图片 可控制单张图片展示时间 可控制循环播放次数
 
 YYCache 【 YYMemoryCache（_YYLinkedMap _YYLinkedMapNode）
            YYDiskCache(YYKVStorage YYKVStorageItem)
          】
 存储：先存入内存 再存入磁盘
 读取：读取内存，不存在再读取磁盘
 使用方法：       YYCache *userInfoCache = [YYCache cacheWithName:@"userInfo"];
                [userInfoCache setObject:@"hjn" forKey:@"name" withBlock:^{
                    NSLog(@"caching object succeed");
                }];
 
**/
#endif /* HHKitMacro_h */
