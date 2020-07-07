//
//  UIColor+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/22.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UIColor+HHUtilities.h"

@implementation UIColor (HHUtilities)
+ (UIColor *)hh_colorWithHexStr:(NSString *)string {
    return [UIColor hh_colorWithHexStr:string alpha:1.0];
}

+ (UIColor *)hh_colorWithHexStr:(NSString *)string alpha:(CGFloat)alpha {
    NSString *str;
    if ([string containsString:@"#"]) {
        str = [string substringFromIndex:1];
    } else {
        str = string;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:str];
    UInt32 hexNum = 0;
    if ([scanner scanHexInt:&hexNum] == NO) {
        NSLog(@"16进制转UIColor, hexString为空");
    }
    
    return [UIColor hh_colorWithR:(hexNum & 0xFF0000) >> 16 g:(hexNum & 0x00FF00) >> 8 b:hexNum & 0x0000FF a:alpha];
}

+ (UIColor *)hh_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}
 
+ (NSString *)hh_hexStringWithColor:(UIColor *)color {
    CGFloat r, g, b, a;
    BOOL bo = [color getRed:&r green:&g blue:&b alpha:&a];
    if (bo) {
        int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
        return [NSString stringWithFormat:@"#%06x", rgb].uppercaseString;
    } else {
        return @"";
    }
}
@end
