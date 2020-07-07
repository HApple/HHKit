//
//  HHKit_WekView.h
//  HHKit
//
//  Created by Jn.Huang on 2020/7/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#ifndef HHKit_WekView_h
#define HHKit_WekView_h

// !Important
// 
// 仅支持iOS11.0以上版本

#ifdef DEBUG
#define HHLog(fmt, ...)   \
NSLog((@"[filename:%s]\n" "[functionname:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
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

#import "WKWebView+HHPost.h"
#import "WKWebView+HHJavaScriptAlert.h"
#import "WKWebView+HHKit.h"
#import "HHWebViewController.h"

#endif /* HHKit_WekView_h */
