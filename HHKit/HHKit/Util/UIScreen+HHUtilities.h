//
//  UIScreen+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (HHUtilities)

+ (BOOL)hh_isIphoneXSeries;
+ (UIWindow *)hh_keyWindow;
+ (CGFloat)hh_safeAreaInsetsTop;
+ (CGFloat)hh_statusBarHeight;
+ (CGFloat)hh_navBarHeight;
+ (CGFloat)hh_safeAreaInsetsBottom;
+ (CGFloat)hh_tabbarHeight;
@end

NS_ASSUME_NONNULL_END
