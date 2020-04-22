//
//  UILabel+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/22.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UILabel+HHUtilities.h"
#import <YYKit/YYKit.h>

@implementation UILabel (HHUtilities)

// MARK: -- 获取内容的 宽度/高度

/// 获取文本内容的宽度,获取宽度前先给label高度
- (CGFloat)hh_getTextWidth {
    return [UILabel hh_getTextWidthWithText:self.text height:self.height font:self.font];
}

/// 获取文本内容的高度,获取高度前先给label宽度
- (CGFloat)hh_getTextHeight {
    return [UILabel hh_getTextHeightWithText:self.text width:self.width font:self.font];
}

+ (CGFloat)hh_getTextWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(newSize.width);
}

+ (CGFloat)hh_getTextWidthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize {
    return [UILabel hh_getTextWidthWithText:text height:height font:[UIFont systemFontOfSize:fontSize]];
}

+ (CGFloat)hh_getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(newSize.height);
}

+ (CGFloat)hh_getTextHeightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    return [UILabel hh_getTextHeightWithText:text width:width font:[UIFont systemFontOfSize:fontSize]];
}

@end
