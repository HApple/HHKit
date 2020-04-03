//
//  NSString+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/3.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "NSString+HHUtilities.h"
#import <CoreText/CoreText.h>

@implementation NSString (HHUtilities)
/** 身份证隐藏四位*/
- (NSString *)hh_hiddenIdCards {
    if (!self || self.length == 0) {
        return @"";
    }
    
    NSMutableString *newUPhone = [NSMutableString stringWithString:self];
    NSRange range = NSMakeRange(self.length-8, 4);
    if (range.location > 0 && (range.location < self.length) && (range.location + range.length) < self.length) {
        [newUPhone replaceCharactersInRange:range withString:@"****"];
    }
    return  newUPhone;
}
/** 手机号隐藏四位*/
- (NSString *)hh_hiddenPhoneNumber {
    if (!self || self.length == 0) {
        return @"";
    }
    NSRange range = NSMakeRange(3, 4);
    if (self.length >= 3 && self.length < 7) {
        range = NSMakeRange(3,self.length-3);
    }else if (self.length < 3){
        range = NSMakeRange(0,self.length);
    }
    // 手机号码
    NSMutableString *newUPhone = [NSMutableString stringWithString:self];
    [newUPhone replaceCharactersInRange:range withString:@"****"];
    return  newUPhone;
}

/** 保留四位小数*/
- (NSString *)hh_keepFourDecimal {
    return [NSString stringWithFormat:@"%.4f",[self doubleValue]];
}

/** 判断电话号码*/
- (BOOL)hh_checkPhoneNumber {
    // 只判断是否1开头 11位就好了
    if (self.length != 11) {
        return NO;
    }
    NSString *regex = @"\\b(1)[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [phoneTest evaluateWithObject:self];
}

/** 判断身份证号*/
- (BOOL)hh_checkIdCardNo {
    if (self.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

/** 判断邮箱地址*/
- (BOOL)hh_checkEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/** 判断是否是纯数字*/
- (BOOL)hh_CheckPureInt {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
 
/** 判断是否是数字字母组合*/
- (BOOL)hh_checkAlphanumericCompose {
    NSString * regex = @"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/** 判断是否是数字字母组合 限制长度范围 [length1 - length2]*/
- (BOOL)hh_checkAlphanumericComposeFromLimitLength1:(NSInteger)length1 andLimitLength2:(NSInteger)length2 {
    BOOL result = NO;
    NSString * regex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{%ld,%ld}$",length1,length2];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:self];
    return result;
}

/** 判断密码*/
- (BOOL)hh_checkPasword:(HHCheckPasswordType)checkType {
    if (checkType == HHCheckPasswordType_Alphanumeric_6) {
        
        // 数字字母组合
        if (self.length == 6 && [self hh_checkAlphanumericCompose]) {
            return YES;
        }
        
    }else if (checkType == HHCheckPasswordType_Alphanumeric_6_20){
        
        //数字字母组合 6-20位
        return [self hh_checkAlphanumericComposeFromLimitLength1:6 andLimitLength2:20];
        
    }else if (checkType == HHCheckPasswordType_Alphanumeric_8_20){
        
        //数字字母组合 8-20位
        return [self hh_checkAlphanumericComposeFromLimitLength1:8 andLimitLength2:20];
    
    }else if (checkType == HHCheckPasswordType_Number_6){
        
        //纯数字 6位
        if (self.length == 6 && [self hh_CheckPureInt]) {
            return YES;
        }
    }
    return NO;
}


/** 获取URL中的参数*/
- (NSDictionary *)hh_UrlParamers {
    NSMutableDictionary *paramer = [[NSMutableDictionary alloc]init];
    //创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self];
    //遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [paramer setObject:obj.value forKey:obj.name];
    }];
    return paramer;
}

@end

//MARK: -- Localize
@implementation NSString (Localize)
- (NSString *)localized {
    NSString *name = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"] stringValue];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:self value:nil table:nil];
}
@end
