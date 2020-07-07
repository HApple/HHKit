//
//  NSObject+HHKit.m
//  HHKit
//
//  Created by Jn.Huang on 2020/6/30.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "NSObject+HHKit.h"
#import <objc/runtime.h>

@implementation NSObject (HHKit)

// MARK: - Swap method (Swizzling)
/// 交换实例方法 为什么要这么写 还未深究 从YYKit中抄的
+ (BOOL)hh_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

/// 交换一个类的两个类方法
+ (BOOL)hh_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) {
        return NO;
    }
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

// MARK: - runtime set/get AssociateValue

- (void)hh_runtime_setValue:(nullable id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hh_runtime_setCopyValue:(nullable id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)hh_runtime_setWeakValue:(nullable id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (nullable id)hh_runtime_getValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

@end
