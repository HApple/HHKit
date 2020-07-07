//
//  UILabel+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/22.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UILabel (HHUtilities)

// MARK: -- 获取内容的 宽度/高度

/// 获取文本内容的宽度,获取宽度前先给label高度
- (CGFloat)hh_getTextWidth;

/// 获取文本内容的高度,获取高度前先给label宽度
- (CGFloat)hh_getTextHeight;

+ (CGFloat)hh_getTextWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;
+ (CGFloat)hh_getTextWidthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize;
+ (CGFloat)hh_getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)hh_getTextHeightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;


// MARK: - 设置文本的颜色 大小 下划线


@end

NS_ASSUME_NONNULL_END
