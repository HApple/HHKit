//
//  UITextView+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/3.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (HHUtilities)

@end




@interface UITextView (HHPlaceholder)

@property (nonatomic, readonly)UILabel *placeholderLabel;

@property (nonatomic, strong)IBInspectable NSString *placeholder;

@property (nonatomic, strong)IBInspectable UIFont *placeholderFont;

@property (nonatomic, strong)IBInspectable UIColor *placeholderColor;

@property (nonatomic, strong)NSAttributedString *attributedPlaceholder;

@end

NS_ASSUME_NONNULL_END
