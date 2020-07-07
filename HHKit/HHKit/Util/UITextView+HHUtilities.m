//
//  UITextView+HHUtilities.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/3.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "UITextView+HHUtilities.h"
#import <objc/runtime.h>

@implementation UITextView (HHUtilities)

@end

@implementation UITextView (HHPlaceholder)

//MARK:  Placeholder
- (UITextView *)placeholderLabel {
    UITextView *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        label = [[UITextView alloc] init];
        label.editable = NO;
        label.selectable = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self hh_updatePlaceholderLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hh_updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return label;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    self.placeholderLabel.font = placeholderFont;
}

- (UIFont *)placeholderFont {
    return self.placeholderLabel.font;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

//MARK:  Update

- (void)hh_updatePlaceholderLabel {
    
    if (self.text.length > 0) {
         self.placeholderLabel.hidden = YES;
     }else {
         self.placeholderLabel.hidden = NO;
         [self insertSubview:self.placeholderLabel atIndex:0];
     }
    self.placeholderLabel.frame = self.bounds;
}
@end


