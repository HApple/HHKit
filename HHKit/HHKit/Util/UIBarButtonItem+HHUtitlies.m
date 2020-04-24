//
//  UIBarButtonItem+HHUtitlies.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/23.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UIBarButtonItem+HHUtitlies.h"
#import <YYKit/YYKit.h>

@implementation UIBarButtonItem (HHUtitlies)

+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button hh_setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}


+ (instancetype)itemWithTitle:(NSString *)title ImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.size = button.currentImage.size;
    button.width += 40;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
