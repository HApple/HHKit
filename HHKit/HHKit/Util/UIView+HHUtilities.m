//
//  UIView+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/3.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UIView+HHUtilities.h"
#import "NSString+HHUtilities.h"
#import <objc/runtime.h>


@implementation UIView (HHUtilities)
//MARK: -- View Util
+(instancetype)hh_nibView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:NULL][0];
}

+(UINib *)hh_nib{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (CGFloat)hh_cellHeight{
    return 0;
}

+ (NSString *)hh_cellIdentify{
    return NSStringFromClass([self class]);
}

+ (CGFloat)hh_viewHeight{
    return 0.0f;
}

+ (CGSize)hh_itemSize{
    return CGSizeZero;
}

#pragma mark - response
- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponser = [next nextResponder];
        
        if ([nextResponser isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponser;
        }
    }
    return nil;
}

@end



//MARK: --  UIView XIB Border
@implementation UIView (XIB)
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    objc_setAssociatedObject(self, @selector(borderColor), borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)borderColor {
    return  objc_getAssociatedObject(self, @selector(borderColor));
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    objc_setAssociatedObject(self, @selector(borderWidth), [NSNumber numberWithFloat:borderWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
    objc_setAssociatedObject(self, @selector(cornerRadius), [NSNumber numberWithFloat:cornerRadius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}
@end


//MARK: --  UIButton/UILabel/UITextField XIB Localizable
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
