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
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//-----------------------------------  状态栏 导航栏 底部高  ------------------------------------
#define  kStatusBarHeight  (IS_IPHONE_X ?  44: 22)
#define  kNavigationBar     44
#define  kAppTopBarMargin  (kStatusBarHeight + kNavigationBar)
#define  kTapBarHeight     (IS_IPHONE_X ? (49+33) : 49)

//-----------------------------------  设备的宽高  ------------------------------------
#ifndef  kScreenWidth
#define  kScreenWidth        [UIScreen mainScreen].bounds.size.width
#endif

#ifndef  kScreenHight
#define  kScreenHight        [UIScreen mainScreen].bounds.size.height
#endif

//-----------------------------------  屏幕适配，IPhone以750X1334为基准，750是宽，1334是高  ------------------------------------
#define kFitScreen(x) [UIScreen fitScreen:x]
#define kFontSize(x)  [UIFont systemFontOfSize:kFitScreen(x)]


//-----------------------------------  颜色  ------------------------------------
#define kNavColor        UIColorHex(fe5e3a)
#define kViewBgColor     UIColorRGB(240,240,240)
#define kLineColor       UIColorHex(999999)
#define kBlackTextColor  UIColorHex(333333)
#define kLightTextColor  UIColorHex(999999)

//----------------------------------- 圆角  ------------------------------------




#endif /* HHUIDefine_h */
