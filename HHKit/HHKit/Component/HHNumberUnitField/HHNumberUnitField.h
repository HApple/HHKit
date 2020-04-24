//
//  HHNumberUnitField.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/23.
//  Copyright © 2020 hjn. All rights reserved.
//
/**
 数字输入框
如：
   ┌┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈┐
   ┆ • ┆ • ┆ • ┆ • ┆
   └┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈┘
   ┌┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈┐
   ┆ 1 ┆ 2 ┆ 3 ┆ 4 ┆
   └┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈┘
   ┌┈┈┈┐┌┈┈┈┐┌┈┈┈┐┌┈┈┈┐
   ┆ 1 ┆┆ 2 ┆┆ 3 ┆┆ 4 ┆
   └┈┈┈┘└┈┈┈┘└┈┈┈┘└┈┈┈┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 兼容性
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    NSNotificationName const HHNumberUnitFieldDidBecomeFirstResponderNotification = @"HHNumberUnitFieldDidBecomeFirstResponderNotification";
    NSNotificationName const HHNumberUnitFieldDidResignFirstResponderNotification = @"HHNumberUnitFieldDidResignFirstResponderNotification";
#else
    NSString *const HHNumberUnitFieldDidBecomeFirstResponderNotification = @"HHNumberUnitFieldDidBecomeFirstResponderNotification";
    NSString *const HHNumberUnitFieldDidResignFirstResponderNotification = @"HHNumberUnitFieldDidResignFirstResponderNotification";
#endif


@protocol HHNumberUnitFieldDelegate;

IB_DESIGNABLE


@interface HHNumberUnitField : UIControl

@property (nullable, nonatomic, weak) id<HHNumberUnitFieldDelegate> numerFieldDelegate;

/// 保留的用户输入的字符串
@property (nullable, nonatomic, copy) NSString *text;

/// 密文 默认值为 NO
@property (nonatomic, assign, getter=isSecureTextEntry) IBInspectable BOOL secureTextEntry;

/// 允许输入的个数  [目前 允许的输入单元个数控制在 1 ~ 8 个. 任何超过该范围内的赋值行为都将被忽略]
@property (nonatomic, assign) IBInspectable NSUInteger enterUnitCount;

/// 每个 Unit 之间的距离 默认为 0
@property (nonatomic, assign) IBInspectable CGFloat unitSpace;

/// Unit 边框圆角
@property (nonatomic, assign) IBInspectable CGFloat borderRadius;

/// 边框宽度 默认为 1
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/// 设置文本字体
@property (nonatomic, strong) IBInspectable UIFont *textFont;

/// 设置文本颜色 默认为黑色
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *textColor;

/// 边框颜色 / 未输入边框颜色(unitSpcae > 2 才有效)
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *borderColor;

/// 已输入边框颜色(unitSpcae > 2 才有效) 默认为 nil
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *enteredBorderColor;

/// 光标颜色 如果设置为空 则不生成光标动画
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *cursorColor;

/// 输入完成后,是否需要自动取消第一响应者. 默认为 NO.
@property (nonatomic, assign) IBInspectable BOOL autoResignFirstResponderWhenEnterFinished;

- (instancetype) initWithEnterUnitCount:(NSUInteger)count;

@end


@protocol HHNumberUnitFieldDelegate <NSObject>

@optional
- (BOOL)hhnumberUnitField:(HHNumberUnitField *)unitField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
