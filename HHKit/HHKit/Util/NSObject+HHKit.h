//
//  NSObject+HHKit.h
//  HHKit
//
//  Created by Jn.Huang on 2020/6/30.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HHKit)

// MARK: - Swap method (Swizzling)
/**
 交换一个类的两个实例方法
 @param originalSel  方法1
 @param newSel       方法2
 @return             YES   如果交换成功，否则返回 NO
 */
+ (BOOL)hh_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 交换一个类的两个类方法
 @param originalSel  方法1
 @param newSel       方法2
 @return             YES   如果交换成功，否则返回 NO
 */
+ (BOOL)hh_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

// MARK: - runtime set/get

/**
 Associate one object to `self`, as if it was a strong property (strong, nonatomic).
 
 @param value   The object to associate.
 @param key     The pointer to get value from `self`.

 */
- (void)hh_runtime_setValue:(nullable id)value withKey:(void *)key;

/**
 Associate one object to `self`, as if it was a copy property (copy, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)hh_runtime_setCopyValue:(nullable id)value withKey:(void *)key;

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).
 
 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)hh_runtime_setWeakValue:(nullable id)value withKey:(void *)key;

/**
 Get the associated value from `self`.
 
 @param key The pointer to get value from `self`.
 */
- (nullable id)hh_runtime_getValueForKey:(void *)key;

@end

NS_ASSUME_NONNULL_END
