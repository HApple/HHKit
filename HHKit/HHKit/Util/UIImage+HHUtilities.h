//
//  UIImage+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HHUtilities)

- (UIImage *)hh_drawRoundedRectImage:(CGFloat)cornerRadius with:(CGFloat)width height:(CGFloat)height;

- (UIImage *)hh_drawCircleImage;

@end

NS_ASSUME_NONNULL_END
