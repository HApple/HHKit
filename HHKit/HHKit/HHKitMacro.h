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
#define  IS_IPHONE_X  [UIDevice isIphoneXSeries]
/// 状态栏 导航栏 底部高
#define  kSafeAreaInsetsTop       [UIDevice hh_safeAreaInsetsTop]
#define  kSafeAreaInsetsBootom    [UIDevice hh_safeAreaInsetsBottom]
#define  kStatusBarHeight         [UIDevice hh_statusBarHeight]
#define  kNavBarHeight            [UIDevice hh_navBarHeight]
#define  kTabBarHeight            [UIDevice hh_tabbarHeight]
/// 屏幕适配，以IPhone6为基准，375是宽，667是高
#define kFitScreen(x) (x * (kScreenWidth / 375.0))
#define kFontSize(x)  [UIFont systemFontOfSize:kFitScreen(x)]

#ifdef DEBUG
#define HHLog(fmt, ...)   \
NSLog((@"[filename:%s]\n" "[functionname:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define HHLog(...);
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
