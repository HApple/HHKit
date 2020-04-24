//
//  UIBarButtonItem+HHUtitlies.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/23.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+HHUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (HHUtitlies)

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title ImageName:(NSString *)imageName target:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
