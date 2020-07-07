//
//  WKWebView+HHPost.m
//  HHKit
//
//  Created by Jn.Huang on 2020/7/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "WKWebView+HHPost.h"
#import <objc/runtime.h>
#import "NSObject+HHKit.h"

@implementation WKWebView (HHPost)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hh_swizzleInstanceMethod:@selector(loadRequest:) with:@selector(hh_post_loadRequest:)];
    });
}

- (WKNavigation *)hh_post_loadRequest:(NSURLRequest *)request {
    if ([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"]) {
        NSString *url = request.URL.absoluteString;
        NSString *params = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if ([params containsString:@"="]) {
            // name=one&password=one -> "name":"one","password":"one"
            params = [params stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
            params = [params stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];
            params = [NSString stringWithFormat:@"{\"%@\"}",params];
        }else {
            params = @"{}";
        }
        
        NSString *postJavaScript = [NSString stringWithFormat:@"\
                                    var url = '%@';\
                                    var params = %@;\
                                    var form = document.createElement('form');\
                                    form.setAttribute('method', 'post');\
                                    form.setAttribute('action', url);\
                                    for(var key in params) {\
                                    if(params.hasOwnProperty(key)) {\
                                    var hiddenField = document.createElement('input');\
                                    hiddenField.setAttribute('type', 'hidden');\
                                    hiddenField.setAttribute('name', key);\
                                    hiddenField.setAttribute('value', params[key]);\
                                    form.appendChild(hiddenField);\
                                    }\
                                    }\
                                    document.body.appendChild(form);\
                                    form.submit();", url, params];
        
        __weak typeof(self) weakSelf = self;
        [self evaluateJavaScript:postJavaScript completionHandler:^(id _Nullable object, NSError * _Nullable error) {
           
            if (error && [weakSelf.navigationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.navigationDelegate webView:weakSelf didFailProvisionalNavigation:nil withError:error];
                });
            }
        }];
        return nil;
    }else {
        return [self hh_post_loadRequest:request];
    }
    
}

@end
