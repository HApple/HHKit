//
//  UIButton+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/23.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIButton (HHUtilities)

@end


// MARK: - 扩大button点击范围
@interface UIButton (HHEnlarge)

- (void)hh_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end


// MARK:- button 样式 以图片为基准
typedef NS_ENUM(NSInteger, HHButtonContentLayoutStyle) {
    HHButtonContentLayoutStyleNormal = 0,           // 内容居中-图左文右
    HHButtonContentLayoutStyleCenterImageRight,     // 内容居中-图右文左
    HHButtonContentLayoutStyleCenterImageTop,       // 内容居中-图上文下
    HHButtonContentLayoutStyleCenterImageBottom,    // 内容居中-图下文上
    HHButtonContentLayoutStyleLeftImageLeft,        // 内容居左-图左文右
    HHButtonContentLayoutStyleLeftImageRight,       // 内容居左-图右文左
    HHButtonContentLayoutStyleRightImageLeft,       // 内容居右-图左文右
    HHButtonContentLayoutStyleRightImageRight,      // 内容居右-图右文左
};

@interface UIButton (HHButtonContentLayout)

/// button的布局样式 文字 字体大小 图片等参数一定要在其之前设置,方便计算
@property (nonatomic, assign) HHButtonContentLayoutStyle hh_buttonContentLayoutType;

/// 图文间距, 默认为: 0
@property (nonatomic, assign) CGFloat hh_padding;

/// 图文边界的间距, 默认为: 5
@property (nonatomic, assign) CGFloat hh_paddingInset;

@end

// MARK: - 添加倒计时功能

@interface UIButton (HHButtonCountDown)

/// 倒计时结束的回调
@property (nonatomic, copy) void(^HH_ButtonTimeStoppedCallBack)(void);

/**
 设置倒计时的间隔和倒计时文案
 
 @param duration 倒计时时间
 @param format   可选,传nil 默认为 @"%zd秒"
 */
- (void)hh_countDownWithTimeInterval:(NSTimeInterval)duration countDownForamt:(NSString *)format;

/// invalidate time
- (void)hh_cancelTimer;

@end


NS_ASSUME_NONNULL_END
