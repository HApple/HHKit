//
//  NSString+HHUtilities.h
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/3.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HHCheckPasswordType){
    /** 数字字母组合 6位*/
    HHCheckPasswordType_Alphanumeric_6,
    /** 数字字母组合 6-20位*/
    HHCheckPasswordType_Alphanumeric_6_20,
    /** 数字字母组合 8-20位*/
    HHCheckPasswordType_Alphanumeric_8_20,
    /** 纯数字 6位*/
    HHCheckPasswordType_Number_6,
};


@interface NSString (HHUtilities)
/** 身份证隐藏四位*/
- (NSString *)hh_hiddenIdCards;
/** 手机号隐藏四位*/
- (NSString *)hh_hiddenPhoneNumber;
/** 保留四位小数*/
- (NSString *)hh_keepFourDecimal;

/** 判断电话号码*/
- (BOOL)hh_checkPhoneNumber;
/** 判断身份证号*/
- (BOOL)hh_checkIdCardNo;
/** 判断邮箱地址*/
- (BOOL)hh_checkEmail;
/** 判断是否是纯数字*/
- (BOOL)hh_CheckPureInt;
/** 判断是否是数字字母组合*/
- (BOOL)hh_checkAlphanumericCompose;
/** 判断是否是数字字母组合 限制长度范围 [length1 - length2]*/
- (BOOL)hh_checkAlphanumericComposeFromLimitLength1:(NSInteger)length1 andLimitLength2:(NSInteger)length2;
/** 判断常用密码 根据 HHCheckPasswordType 选择对应模式*/
- (BOOL)hh_checkPasword:(HHCheckPasswordType)checkType;

/** 获取URL中的参数*/
- (NSDictionary *)hh_UrlParamers;

/** 根据color font 生成 attributedString*/
- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color font:(UIFont *)font;

@end

//MARK: -- Localize
@interface NSString (Localize)
- (NSString *)localized;
@end

NS_ASSUME_NONNULL_END
