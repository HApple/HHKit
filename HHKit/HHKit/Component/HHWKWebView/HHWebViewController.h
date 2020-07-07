//
//  HHWebViewController.h
//  HHKit
//
//  Created by Jn.Huang on 2020/7/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHWebViewController : UIViewController

@property (nonatomic, strong) UIColor * _Nullable hh_web_progressTintColor;
@property (nonatomic, strong) UIColor * hh_web_progressTrackTintColor;

/**
*  加载一个 webview
*
*  @param request 请求的 NSURL URLRequest
*/
- (void)hh_web_loadRequest:(NSURLRequest *)request;

/**
 *  加载一个 webview
 *
 *  @param URL 请求的 URL
 */
- (void)hh_web_loadURL:(NSURL *)URL;

/**
 *  加载一个 webview
 *
 *  @param URLString 请求的 URLString
 */
- (void)hh_web_loadURLString:(NSString *)URLString;

/**
 *  加载本地网页
 *
 *  @param htmlName 请求的本地 HTML 文件名
 */
- (void)hh_web_loadHTMLFileName:(NSString *)htmlName;

/**
 *  加载本地 htmlString
 *
 *  @param htmlString 请求的本地 htmlString
 */
- (void)hh_web_loadHTMLString:(NSString *)htmlString;

/**
 *  加载 js 字符串，例如：高度自适应获取代码：
 // webView 高度自适应
 [self hh_web_stringByEvaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
 // 获取页面高度，并重置 webview 的 frame
 self.hh_web_currentHeight = [result doubleValue];
 CGRect frame = webView.frame;
 frame.size.height = self.hh_web_currentHeight;
 webView.frame = frame;
 }];
 *
 *  @param javaScriptString js 字符串
 */
- (void)hh_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;


@end

NS_ASSUME_NONNULL_END
