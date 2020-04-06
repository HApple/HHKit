//
//  UITextField+HHUtilities.m
//  HHKit
//
//  Created by Jn.Huang on 2020/4/4.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UITextField+HHUtilities.h"
#import <objc/runtime.h>
#import "HHKitMacro.h"

@interface UITextField ()

@end

@implementation UITextField (HHUtilities)

// MARK: Logic
- (void)hh_handleTextFieldTextDidChangeAction {
    
    NSString *toBeginString = self.text;
    
    // 获取高亮部分
    UITextRange *selectRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectRange.start offset:0];
    
    /*
     需要判断markedTextRange是不是为nil 如果为nil的话就说明现在没有未选中的字符 可以计算文字长度
     否则此时计算出来的字符长度可能不正确
    */
    if (position || selectRange){
        return;
    }
    
    /*
      没有高亮选择的字 则对已输入的文字进行字数统计和限制
     */
    if (self.hh_maxLength > 0 && toBeginString.length > self.hh_maxLength) {
        self.text = [toBeginString substringToIndex:self.hh_maxLength];
    }
}

// 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // 删除
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    BOOL isHaveDecimalPoint = NO;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDecimalPoint = NO;
    }else {
        isHaveDecimalPoint = YES;
    }
        
    // 当前输入的字符
    unichar single = [string characterAtIndex:0];
    
    // 小数点禁止输入
    if (self.hh_pointInputDisable && single == '.') {
        HHLog(@"小数点禁止输入");
        [textField.text stringByReplacingCharactersInRange:range withString:@""];
        return NO;
    }
    
    // 数据格式正确
    if ((single >= '0' && single <= '9') || single == '.') {
        
        // 首字母不能为小数点
        if ([textField.text length] == 0) {
            if (single == '.') {
                HHLog(@"第一个数字不能为小数点");
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        
        // 首字母不能为 0
        if (self.hh_firstZeroDisable) {
            if (single == '0') {
                HHLog(@"第一个数字不能为0");
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        
        // 首位为0，后面一位仅能输入小数点
        if(self.hh_moneyInputEnable && [textField.text length] == 1 && [textField.text isEqualToString:@"0"])
        {
            if(single != '.')
            {
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }

        // 输入的字符是否是小数点
        if (single == '.') {
            
            // 已经输入过小数点了
            if(isHaveDecimalPoint) {
                HHLog(@"您已经输入过小数点了");
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }else {
                return YES;
            }
        }else {
            
            // 存在小数点
            if (isHaveDecimalPoint) {
                // 判断小数点的位数
                NSRange ran = [textField.text rangeOfString:@"."];
                if (range.location - ran.location <= self.hh_maxDecimalPointNumber) {
                    return YES;
                }else {
                    HHLog(@"您最多输入%ld位小数",(long)self.hh_maxDecimalPointNumber);
                    return NO;
                }
            }else {
                return YES;
            }
            
        }
    }
    else {
        
        // 输入的数据格式不正确
        HHLog(@"您输入的格式不正确");
        [textField.text stringByReplacingCharactersInRange:range withString:@""];
        return NO;
    }
}

- (void)hh_setKeyboadTypeAndDelegate {
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.delegate = self;
}


// MARK: - Setter / Getter
- (void)setHh_maxLength:(NSInteger)hh_maxLength {
    objc_setAssociatedObject(self, @selector(hh_maxLength), @(hh_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(hh_handleTextFieldTextDidChangeAction) forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)hh_maxLength {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHh_moneyInputEnable:(BOOL)hh_moneyInputEnable {
    
    objc_setAssociatedObject(self, @selector(hh_moneyInputEnable), @(hh_moneyInputEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //默认限制小数点后4位
    self.hh_maxDecimalPointNumber = 4;
    
    [self hh_setKeyboadTypeAndDelegate];
}

- (BOOL)hh_moneyInputEnable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHh_pointInputDisable:(BOOL)hh_pointInputDisable {
    objc_setAssociatedObject(self, @selector(hh_pointInputDisable), @(hh_pointInputDisable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self hh_setKeyboadTypeAndDelegate];
}

- (BOOL)hh_pointInputDisable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHh_maxDecimalPointNumber:(NSInteger)hh_maxDecimalPointNumber {
    
    objc_setAssociatedObject(self, @selector(hh_maxDecimalPointNumber), @(hh_maxDecimalPointNumber), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self hh_setKeyboadTypeAndDelegate];
}

- (NSInteger)hh_maxDecimalPointNumber {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setHh_firstZeroDisable:(BOOL)hh_firstZeroDisable {
    objc_setAssociatedObject(self, @selector(hh_firstZeroDisable), @(hh_firstZeroDisable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self hh_setKeyboadTypeAndDelegate];
}

- (BOOL)hh_firstZeroDisable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end
