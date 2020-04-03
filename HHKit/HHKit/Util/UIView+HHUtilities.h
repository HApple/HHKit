//
//  UIView+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/3.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MARK: -- View Util
@interface UIView (HHUtilities)
+ (instancetype)hh_nibView;
+ (UINib *)hh_nib;
+ (CGFloat)hh_cellHeight;
+ (NSString *)hh_cellIdentify;
+ (CGFloat)hh_viewHeight;
+ (CGSize)hh_itemSize;
@end


//MARK: --  UIView XIB Border
@interface UIView (XIB)

@property (nonatomic, strong)IBInspectable UIColor *borderColor;

@property (nonatomic, assign)IBInspectable CGFloat borderWidth;

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@end

//MARK: --  UIButton/UILabel/UITextField XIB Localizable
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
