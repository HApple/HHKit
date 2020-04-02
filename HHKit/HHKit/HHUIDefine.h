//
//  HHUIDefine.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#ifndef HHUIDefine_h
#define HHUIDefine_h


//-----------------------------------  IPHONE_X 判断  ------------------------------------
#define  IS_IPHONE_X  [UIDevice isIphoneXSeries]

//-----------------------------------  状态栏 导航栏 底部高  ------------------------------------
#define  kSafeAreaInsetsTop       [UIDevice hh_safeAreaInsetsTop]
#define  kSafeAreaInsetsBootom    [UIDevice hh_safeAreaInsetsBottom]
#define  kStatusBarHeight         [UIDevice hh_statusBarHeight]
#define  kNavBarHeight            [UIDevice hh_navBarHeight]
#define  kTabBarHeight            [UIDevice hh_tabbarHeight]

//-----------------------------------  设备的宽高  ------------------------------------
#ifndef  kScreenWidth
#define  kScreenWidth        [UIScreen mainScreen].bounds.size.width
#endif

#ifndef  kScreenHight
#define  kScreenHight        [UIScreen mainScreen].bounds.size.height
#endif

//-----------------------------------  屏幕适配，以IPhone6为基准，375是宽，667是高  ------------------------------------
#define kFitScreen(x) (x * (kScreenWidth / 375.0))
#define kFontSize(x)  [UIFont systemFontOfSize:kFitScreen(x)]


//-----------------------------------  颜色  ------------------------------------
#define kNavColor        UIColorHex(fe5e3a)
#define kViewBgColor     UIColorRGB(240,240,240)
#define kLineColor       UIColorHex(999999)
#define kBlackTextColor  UIColorHex(333333)
#define kLightTextColor  UIColorHex(999999)

//----------------------------------- 圆角  ------------------------------------




#endif /* HHUIDefine_h */
