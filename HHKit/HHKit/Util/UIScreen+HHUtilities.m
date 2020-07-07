//
//  UIScreen+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UIScreen+HHUtilities.h"

@implementation UIScreen (HHUtilities)

+ (BOOL)hh_isIphoneXSeries {
    UIWindow *window = [self hh_keyWindow];
    if (@available(iOS 11.0, *)) {
        if (window.safeAreaInsets.bottom > 0) {
            return YES;
        }
    } else {
        return NO;
    }
    return NO;
}

+ (UIWindow *)hh_keyWindow {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        window = [UIApplication sharedApplication].windows.firstObject;
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}


+ (CGFloat)hh_statusBarHeight {
     UIWindow *window = [self hh_keyWindow];
    if (@available(iOS 13.0, *)) {
        return [window.windowScene.statusBarManager statusBarFrame].size.height;
    } else {
        return [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
}


+ (CGFloat)hh_safeAreaInsetsTop {
    UIWindow *window = [self hh_keyWindow];
    if (@available(iOS 11.0, *)) {
        return window.safeAreaInsets.top;
    } else {
        return [self hh_statusBarHeight];
    }
}


+ (CGFloat)hh_navBarHeight {
    return [self hh_safeAreaInsetsTop] + 44.0f;
}


+ (CGFloat)hh_tabbarHeight {
    return [self hh_safeAreaInsetsBottom] + 49.0f;
}


+ (CGFloat)hh_safeAreaInsetsBottom {
    UIWindow *window = [self hh_keyWindow];
    if (@available(iOS 11.0, *)) {
        return window.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

@end

