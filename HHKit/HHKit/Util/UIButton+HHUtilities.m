//
//  UIButton+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/23.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UIButton+HHUtilities.h"
#import <objc/runtime.h>

@implementation UIButton (HHUtilities)
@end



// MARK: - 扩大button点击范围
@implementation UIButton (HHEnlarge)

static char ktopNameKey;
static char krightNameKey;
static char kbottomNameKey;
static char kleftNameKey;

- (void)hh_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &ktopNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &krightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &kbottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &kleftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CGRect)enlargedRect{
    NSNumber* topEdge    = objc_getAssociatedObject(self, &ktopNameKey);
    NSNumber* rightEdge  = objc_getAssociatedObject(self, &krightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &kbottomNameKey);
    NSNumber* leftEdge   = objc_getAssociatedObject(self, &kleftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else{
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds)){
        return [super pointInside:point withEvent:event];
    }else{
        return CGRectContainsPoint(rect, point);
    }
}
@end


// MARK:- button 样式 以图片为基准

@implementation UIButton (HHButtonContentLayout)


- (void)hh_setupButtonLayout {
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat image_w = self.imageView.frame.size.width;
    CGFloat image_h = self.imageView.frame.size.height;
    
    CGFloat title_w = self.titleLabel.frame.size.width;
    CGFloat title_h = self.titleLabel.frame.size.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中的titleLabel的size为0,用下面的设置
        title_w = self.titleLabel.intrinsicContentSize.width;
        title_h = self.titleLabel.intrinsicContentSize.height;
    }
    
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    
    if (self.hh_paddingInset == 0) {
        self.hh_paddingInset = 5;
    }
    
    switch (self.hh_buttonContentLayoutType) {
        case HHButtonContentLayoutStyleNormal:{
            titleEdge = UIEdgeInsetsMake(0, self.hh_padding, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.hh_padding);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case HHButtonContentLayoutStyleCenterImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -image_w - self.hh_padding, 0, image_w);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.hh_padding, 0, -title_w);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case HHButtonContentLayoutStyleCenterImageTop:{
            titleEdge = UIEdgeInsetsMake(0, -image_w, -image_h - self.hh_padding, 0);
            imageEdge = UIEdgeInsetsMake(-title_h - self.hh_padding, 0, 0, -title_w);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case HHButtonContentLayoutStyleCenterImageBottom:{
            titleEdge = UIEdgeInsetsMake(-image_h - self.hh_padding, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -title_h - self.hh_padding, -title_w);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case HHButtonContentLayoutStyleLeftImageLeft:{
            titleEdge = UIEdgeInsetsMake(0, self.hh_padding + self.hh_paddingInset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, self.hh_paddingInset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case HHButtonContentLayoutStyleLeftImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -image_w + self.hh_paddingInset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.hh_padding + self.hh_paddingInset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case HHButtonContentLayoutStyleRightImageLeft:{
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.hh_padding + self.hh_paddingInset);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.hh_paddingInset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case HHButtonContentLayoutStyleRightImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -self.frame.size.width / 2, 0, image_w + self.hh_padding + self.hh_paddingInset);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -title_w + self.hh_paddingInset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        default:break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
    [self setNeedsDisplay];
    
}

- (void)setHh_buttonContentLayoutType:(HHButtonContentLayoutStyle)hh_buttonContentLayoutType {
    objc_setAssociatedObject(self, @selector(hh_buttonContentLayoutType), @(hh_buttonContentLayoutType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HHButtonContentLayoutStyle)hh_buttonContentLayoutType {
    return [objc_getAssociatedObject(self, @selector(hh_buttonContentLayoutType)) integerValue];
}

- (void)setHh_padding:(CGFloat)hh_padding {
    objc_setAssociatedObject(self, @selector(hh_padding), @(hh_padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)hh_padding {
    return [objc_getAssociatedObject(self, @selector(hh_padding)) floatValue];
}

- (void)setHh_paddingInset:(CGFloat)hh_paddingInset {
    objc_setAssociatedObject(self, @selector(hh_paddingInset), @(hh_paddingInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)hh_paddingInset {
    return [objc_getAssociatedObject(self, @selector(hh_paddingInset)) floatValue];
}

@end


// MARK: - 添加倒计时功能
@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval hh_leaveTime;
@property (nonatomic, copy) NSString *hh_normalTitle;
@property (nonatomic, copy) NSString *hh_countDownFormat;
@property (nonatomic, strong) dispatch_source_t hh_timer;

@end

@implementation UIButton (HHButtonCountDown)

- (void)hh_countDownWithTimeInterval:(NSTimeInterval)duration countDownForamt:(NSString *)format {
    
    if (!format) {
        self.hh_countDownFormat = @"%zd秒";
    } else {
        self.hh_countDownFormat = format;
    }
    
    self.hh_normalTitle = self.titleLabel.text;
    
    __block NSInteger timeOut = duration; //倒计时时间
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.hh_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //每秒执行
    dispatch_source_set_timer(self.hh_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.hh_timer, ^{
        
        if (timeOut <= 0) { //倒计时结束
            [weakSelf hh_cancelTimer];
        } else {
            NSString *title = [NSString stringWithFormat:weakSelf.hh_countDownFormat,timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = YES;
                [weakSelf setTitle:title forState:UIControlStateNormal];
            });
            timeOut--;
        }
    });
    
    dispatch_resume(self.hh_timer);
}

- (void)hh_cancelTimer {
    dispatch_source_cancel(self.hh_timer);
    self.hh_timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
       //设置界面的按钮显示,根据自己需求设置
        [self setTitle:self.hh_normalTitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.HH_ButtonTimeStoppedCallBack) {
            self.HH_ButtonTimeStoppedCallBack();
        }
    });
}

- (void)setHh_leaveTime:(NSTimeInterval)hh_leaveTime {
    objc_setAssociatedObject(self, @selector(hh_leaveTime), @(hh_leaveTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)hh_leaveTime {
    return [objc_getAssociatedObject(self, @selector(hh_leaveTime)) doubleValue];
}

- (void)setHh_normalTitle:(NSString *)hh_normalTitle {
    objc_setAssociatedObject(self, @selector(hh_normalTitle), hh_normalTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)hh_normalTitle {
    return objc_getAssociatedObject(self, @selector(hh_normalTitle));
}

- (void)setHh_countDownFormat:(NSString *)hh_countDownFormat {
    objc_setAssociatedObject(self, @selector(hh_countDownFormat), hh_countDownFormat, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)hh_countDownFormat {
    return objc_getAssociatedObject(self, @selector(hh_countDownFormat));
}

-(void)setHh_timer:(dispatch_source_t)hh_timer {
    objc_setAssociatedObject(self, @selector(hh_timer), hh_timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)hh_timer {
    return objc_getAssociatedObject(self, @selector(hh_timer));
}

- (void)setHH_ButtonTimeStoppedCallBack:(void (^)(void))HH_ButtonTimeStoppedCallBack {
    objc_setAssociatedObject(self, @selector(HH_ButtonTimeStoppedCallBack), HH_ButtonTimeStoppedCallBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))HH_ButtonTimeStoppedCallBack {
    return objc_getAssociatedObject(self, @selector(HH_ButtonTimeStoppedCallBack));
}
@end
