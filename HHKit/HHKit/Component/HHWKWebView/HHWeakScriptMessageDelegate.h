//
//  HHWeakScriptMessageDelegate.h
//  HHKit
//
//  Created by Jn.Huang on 2020/6/28.
//  Copyright © 2020 hjn. All rights reserved.
//
// ----- 解决无法释放的问题 -----
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id <WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>) scriptDelegate;

@end

NS_ASSUME_NONNULL_END
