//
//  UIColor+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/22.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HHUtilities)
+ (UIColor *)hh_colorWithHexStr:(NSString *)string;
+ (UIColor *)hh_colorWithHexStr:(NSString *)string alpha:(CGFloat)alpha;
+ (UIColor *)hh_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;
+ (NSString *)hh_hexStringWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
