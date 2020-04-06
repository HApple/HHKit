//
//  UITextField+HHUtilities.h
//  HHKit
//
//  Created by Jn.Huang on 2020/4/4.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (HHUtilities)<UITextFieldDelegate>

/** 限制最大输入长度*/
@property (nonatomic, assign) NSInteger hh_maxLength;


// 注意！！！ 以下属性
// 自动设置
// delegate = self
// keyboardType = UIKeyboardTypeDecimalPad;
// 有数字 金额方面的需求可以使用
/**
    金额带小数点
    所做限制
            - 首位不能为小数点
            - 小数点后最大位数默认为4 您可以通过 hh_maxDecimalPointNumber 更改
            - 如果首位为0，后面一位仅能输入小数点
            - 控制输入长度 您可以通过设置 hh_maxLength 控制
            - 通过设置 hh_pointInputEnable 为 NO 即是金额不带小数点的整数
 */
@property (nonatomic, assign) BOOL hh_moneyInputEnable;

/** 是否可以输入小数点 默认可以*/
@property (nonatomic, assign) BOOL hh_pointInputDisable;

/** 小数点后最大的位数 默认无限制*/
@property (nonatomic, assign) NSInteger hh_maxDecimalPointNumber;

/** 首位数是否可以为0 默认可以*/
@property (nonatomic, assign) BOOL hh_firstZeroDisable;

@end

NS_ASSUME_NONNULL_END
