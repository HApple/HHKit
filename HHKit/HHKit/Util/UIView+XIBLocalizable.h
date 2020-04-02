//
//  UIView+XIBLocalizable.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (XIBLocalizable)
@property (nonatomic, copy)IBInspectable NSString *xibLocKey;
@end

@interface UILabel (XIBLocalizabe)
@property (nonatomic, copy)IBInspectable NSString *xibLocKey;
@end

@interface UITextField (XIBLocalizable)
@property (nonatomic, copy)IBInspectable NSString *xibLocplaceHKey;
@end

NS_ASSUME_NONNULL_END
