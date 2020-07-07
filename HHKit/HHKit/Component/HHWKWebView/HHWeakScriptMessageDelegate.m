//
//  HHWeakScriptMessageDelegate.m
//  HHKit
//
//  Created by Jn.Huang on 2020/6/28.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHWeakScriptMessageDelegate.h"

@implementation HHWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
