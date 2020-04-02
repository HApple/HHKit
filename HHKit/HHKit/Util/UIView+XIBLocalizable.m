//
//  UIView+XIBLocalizable.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UIView+XIBLocalizable.h"
#import "NSString+Localize.h"
#import <objc/runtime.h>

@implementation UIButton (XIBLocalizable)
- (void)setXibLocKey:(NSString *)xibLocKey {
    [self setTitle:xibLocKey.localized forState:UIControlStateNormal];
}
- (NSString *)xibLocKey {
    return @"";
}
@end

@implementation UILabel (XIBLocalizabe)
- (void)setXibLocKey:(NSString *)xibLocKey {
    self.text = xibLocKey.localized;
}
- (NSString *)xibLocKey {
    return @"";
}
@end

@implementation UITextField (XIBLocalizable)
- (void)setXibLocplaceHKey:(NSString *)xibLocplaceHKey {
    self.placeholder = xibLocplaceHKey.localized;
}
- (NSString *)xibLocplaceHKey {
    return @"";
}
@end
