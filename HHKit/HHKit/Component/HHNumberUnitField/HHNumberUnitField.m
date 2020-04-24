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
            self->_cursorLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / _enterUnitCount / 2, CGRectGetHeight(self.bounds) / 2);
        }];
    }
    return _cursorLayer;
}


@end
