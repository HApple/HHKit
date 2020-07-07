//
//  HHNumberUnitField.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/23.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHNumberUnitField.h"

#define DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(c) CGSizeMake(44 * c, 44)

@interface HHNumberUnitField () <UIKeyInput,UITextInputTraits>

@property (nonatomic, strong) NSMutableArray *characterArray;
@property (nonatomic, strong) CALayer *cursorLayer;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic) CGContextRef ctx;

@end


@implementation HHNumberUnitField

@dynamic text;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;

- (instancetype)initWithEnterUnitCount:(NSUInteger)count {
    if (self = [super initWithFrame:CGRectZero]) {
        NSCAssert(count > 0, @"HHNumberUnitField must have one or more input units.");
        NSCAssert(count <= 8, @"HHNumberUnitField can not have more than 8 input units.");
        _enterUnitCount = count;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _enterUnitCount = 4;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _enterUnitCount = 4;
        [self initialize];
    }
    
    return self;
}

- (instancetype)init{
    if (self == [super init]) {
        _enterUnitCount = 4;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    [super setBackgroundColor:[UIColor clearColor]];
    _characterArray = [NSMutableArray array];
    _secureTextEntry = NO;
    _unitSpace = 12;
    _borderRadius = 0;
    _borderWidth = 1;
    _textFont = [UIFont systemFontOfSize:12];
    _keyboardType = UIKeyboardTypeNumberPad;
    _returnKeyType = UIReturnKeyDone;
    _enablesReturnKeyAutomatically = YES;
    _autoResignFirstResponderWhenEnterFinished = NO;
    _textColor = [UIColor darkGrayColor];
    _borderColor = [UIColor lightGrayColor];
    _enteredBorderColor = [UIColor orangeColor];
    _cursorColor = [UIColor orangeColor];
    _backgroundColor = _backgroundColor ?: [UIColor clearColor];
    self.cursorLayer.backgroundColor = _cursorColor.CGColor;
    
    [self.layer addSublayer:self.cursorLayer];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNeedsDisplay];
    }];
      
}

// MARK: - Property
- (NSString *)text {
    if (_characterArray.count == 0) {
        return nil;
    }
    return [_characterArray componentsJoinedByString:@""];
}

- (void)setText:(NSString *)text {
    [_characterArray removeAllObjects];
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        if (self.characterArray.count < self.enterUnitCount) {
            [self.characterArray addObject:substring];
        }else {
            *stop = YES;
        }
    }];
    [self setNeedsDisplay];
}

- (CALayer *)cursorLayer {
    if (!_cursorLayer) {
        _cursorLayer = [CALayer layer];
        _cursorLayer.hidden = YES;
        _cursorLayer.opacity = 1;
        
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animate.fromValue = @(0);
        animate.toValue = @(1.0);
        animate.duration = 0.5;
        animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animate.autoreverses = YES;
        animate.removedOnCompletion = NO;
        animate.fillMode = kCAFillModeForwards;
        animate.repeatCount = HUGE_VALF;
        
        [_cursorLayer addAnimation:animate forKey:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self layoutIfNeeded];
            self->_cursorLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / self->_enterUnitCount / 2, CGRectGetHeight(self.bounds) / 2);
        }];
    }
    return _cursorLayer;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setEnterUnitCount:(NSUInteger)enterUnitCount {
    if (_enterUnitCount < 1 || _enterUnitCount > 8) {
        return;
    }
    
    _enterUnitCount = enterUnitCount;
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setUnitSpace:(CGFloat)unitSpace {
    if (unitSpace < 0) { return; }
    if (unitSpace < 2) { unitSpace = 0;}
    
    _unitSpace = unitSpace;
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
    
}

- (void)setTextFont:(UIFont *)textFont {
    if (textFont == nil) {
        _textFont = [UIFont systemFontOfSize:22];
    }else {
        _textFont = textFont;
    }
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor == nil) {
        _textColor = [UIColor blackColor];
    }else {
        _textColor = textColor;
    }
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setBorderRadius:(CGFloat)borderRadius {
    if (borderRadius < 0) { return; }
    
    _borderRadius = borderRadius;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0) { return; }
    
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor == nil) {
        _backgroundColor = [UIColor blackColor];
    }else {
        _backgroundColor = backgroundColor;
    }
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor == nil) {
        _borderColor = [[UIView appearance] tintColor];
    }else {
        _borderColor = borderColor;
    }
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setEnteredBorderColor:(UIColor *)enteredBorderColor {
    _enteredBorderColor = enteredBorderColor;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
    _cursorLayer.backgroundColor = _cursorColor.CGColor;
    [self _resetCursorStateIfNeeded];
}


// MARK: - Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self becomeFirstResponder];
}

// MARK: - Override

- (CGSize)intrinsicContentSize {
    [self layoutIfNeeded];
    CGSize size = self.bounds.size;
    
    if (size.width < DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(_enterUnitCount).width) {
        size.width = DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(_enterUnitCount).width;
    }
    CGFloat unitWidth = (size.width + _unitSpace) / _enterUnitCount - _unitSpace;
    size.height = unitWidth;
    
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    [self _resetCursorStateIfNeeded];
    
    if (result == YES) {
        [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
        [[NSNotificationCenter defaultCenter] postNotificationName:HHNumberUnitFieldDidBecomeFirstResponderNotification object:nil];
    }
    
    return result;
}

- (BOOL)canResignFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    BOOL result = [super resignFirstResponder];
    [self _resetCursorStateIfNeeded];
    
    if (result) {
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
        [[NSNotificationCenter defaultCenter] postNotificationName:HHNumberUnitFieldDidResignFirstResponderNotification object:nil];
    }
    return result;
}

- (void)drawRect:(CGRect)rect {
    /**
     绘制的线条具有宽度 因此在绘制时需要考虑该因素对绘制效果的影响
     */
   //    CGSize unitSize =
    
}


// MARK: - Private

/**
 在 AutoLayout 环境下重新指定控件本身的固有尺寸
 `-drawRect` 方法会计算控件完成自身的绘制所需的合适尺寸 完成一次绘制后会通知 AutoLayout 系统更新尺寸.
 */
- (void)_resize {
    [self invalidateIntrinsicContentSize];
}


/**
 绘制背景色 以及剪裁绘制区域
 
 @param rect 控件绘制的区域
 @param clip 剪裁区域同时被 borderRadius 的影响
 */
- (void)_fillRect:(CGRect)rect clip:(BOOL)clip {
    [_backgroundColor setFill];
    if (clip) {
        CGContextAddPath(_ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_borderWidth].CGPath);
        CGContextClip(_ctx);
    }
    CGContextAddPath(_ctx, [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, _borderWidth * 0.75, _borderWidth * 0.75) cornerRadius:_borderRadius].CGPath);
    CGContextFillPath(_ctx);
}

/**
 绘制边框
 
 边框的绘制分为两种模式: 连续喝不连续 其模式的切换由 unitSpace 属性决定
 当 
 */



- (void)_resetCursorStateIfNeeded {
    //_cursorLayer.hidden = !self.isFirstResponder || _cursorColor == nil || _
}
@end
