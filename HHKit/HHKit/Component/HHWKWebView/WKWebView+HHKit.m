//
//  WKWebView+HHKit.m
//  HHKit
//
//  Created by Jn.Huang on 2020/6/28.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "WKWebView+HHKit.h"
#import "WKWebView+HHJavaScriptAlert.h"
#import "HHWeakScriptMessageDelegate.h"
#import "NSObject+HHKit.h"
#import <objc/runtime.h>


@interface WKWebView ()

@property (nonatomic, assign) CGFloat hh_webViewHeight;

@end

@implementation WKWebView (HHKit)

//MARK: - hook
/**
 添加 WKWebView 的代理， 注意： 用此方法添加代理，例如:
 HHKit_WeakSelf
 [self.webView hh_web_initWithDelegate:weak_self.webView uiDelegate:weak_self.webView];
 
 @param navigationDelegate navigationDelegate
 @param uiDelegate uiDelegate
 */
- (void)hh_web_initWithDelegate:(id<WKNavigationDelegate>)navigationDelegate        uiDelegate:(id<WKUIDelegate>)uiDelegate {
    self.navigationDelegate = navigationDelegate;
    self.UIDelegate = uiDelegate;
    [self hh_web_addObserver];
}

- (void)hh_web_dealloc {
    [self hh_web_removeObserver];
}

- (void)hh_web_removeObserver {
    @try {
        
        [self removeObserver:self forKeyPath:kHHKit_WK_title];
        [self removeObserver:self forKeyPath:kHHKit_WK_estimatedProgress];
        [self removeObserver:self forKeyPath:kHHKit_WK_URL];
        [self removeObserver:self forKeyPath:kHHKit_WK_loading];
        
        
        if (self.hh_web_isAutoHeight) {
            [self.scrollView removeObserver:self forKeyPath:kHHKit_WK_contentSize];
        }
        
    } @catch (NSException *exception) {
        // Handle an exception thrown in the @try block[处理@try块中抛出的异常]
    } @finally {
        // Code that gets executed whether or not an exception is thrown[无论是否抛出异常，执行的代码都是被执行的]
    }
    
}

- (void)hh_web_addObserver {
    
    // 获取页面标题
    [self addObserver:self forKeyPath:kHHKit_WK_title options:NSKeyValueObservingOptionNew context:nil];
    
    // 当前页面载入进度
    [self addObserver:self forKeyPath:kHHKit_WK_estimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听 URL， 当之前的 URL 不为空， 而新的 URL 为空时则表示进程被终止
    [self addObserver:self forKeyPath:kHHKit_WK_URL options:NSKeyValueObservingOptionNew context:nil];
    
    // 加载
    [self addObserver:self forKeyPath:kHHKit_WK_loading options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kHHKit_WK_title]) {
        if (object == self) {
            if (self.hh_web_getTitleBlock) {
                self.hh_web_getTitleBlock(self.title);
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:kHHKit_WK_estimatedProgress]) {
        if (object == self) {
            if (self.hh_web_isLoadingBlock) {
                self.hh_web_isLoadingBlock(self.loading, self.estimatedProgress);
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:kHHKit_WK_URL]) {
        
        if (self.hh_web_getCurrentUrlBlock) {
            self.hh_web_getCurrentUrlBlock(self.URL);
        }
    }else if ([keyPath isEqualToString:kHHKit_WK_contentSize] && [object isEqual:self.scrollView]) {
        __block CGFloat height = floorf([change[NSKeyValueChangeNewKey] CGSizeValue].height);
        if (height != self.hh_webViewHeight) {
            self.hh_webViewHeight = height;
            
            CGRect frame = self.frame;
            frame.size.height = height;
            self.frame = frame;
            
            if (self.hh_web_getCurrentHeightBlock) {
                self.hh_web_getCurrentHeightBlock(height);
            }
        }else if (height == self.hh_webViewHeight && height > 0.f) {
            
        }
    }else if ([keyPath isEqualToString:kHHKit_WK_loading]){
            
        if (self.hh_web_isLoadingBlock) {
            self.hh_web_isLoadingBlock(self.loading, 1.0f);
        }

    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#ifndef NSFoundationVersionNumber_iOS_9_0
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0)
{
    NSLog(@"进程被终止 %@",webView.URL);
}
#else

#endif

// MARK: - custom Method
- (BOOL)hh_externalAppRequiredToOpenURL:(NSURL *)url {
    // 若需要限制只允许某些前缀的scheme通过请求，则取消下述注释，并在数组内添加自己需要放行的前缀
    //    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
    //    return ![validSchemes containsObject:url.scheme];
    return !url;
}

// MARK: - WKScriptMessageHandler
/**
 *  JS 调用 OC 时 webView 会调用此方法
 *  @param userContentController     webView 中配置的 userContentController 信息
 *  @param message                   JS执行传递的信息
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 这里可以通过 name 出来多组交互
    // body 只支持 NSNumber NSString NSDate NSArray NSDictionary 和 NSNull 类型
    // NSLog(@"JS 中 message Body : %@", message.body);
    
    if (self.hh_web_userContentControllerDidReceiveScriptMessageBlock) {
        self.hh_web_userContentControllerDidReceiveScriptMessageBlock(userContentController, message);
    }
}

// MARK: - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// MARK: - WKNavigationDelegate
// MARK: - 这个代理方法表示客户端收到服务器的响应头， 根据 response 相关信息，可以决定这次跳转是否可以继续进行。在发送请求之前，决定是否跳转，如果不添加这个，那么 wkwebView 跳转不了 AppStore 和 打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    NSString *url_scheme = url.scheme;
    
    if ([url_scheme isEqualToString:self.hh_web_urlScheme]) {
        if (self.hh_web_decidePolicyForNavigationActionBlock) {
            self.hh_web_decidePolicyForNavigationActionBlock(url);
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // AppStore
    if ([url.absoluteString containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:nil completionHandler:^(BOOL success) {
            
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 调用电话
    if ([url.scheme isEqualToString:@"tel"]) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                
            }];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    /* 参数 WKNavigationAction 中有两个属性： sourceFrame 和 targetFrame, 分别代表这个 action 的出处和目标，
     类型是 WKFrameInfo WKFrameInfo有一个 mainFrame 的属性，标记 frame 是在主 frame 里显示还是新开一个 frame显示
     WKFrameInfo *frameInfo = navigationAction.targetFrame;
     BOOL isMainFrame = [frameInfo isMainFrame];
    */
    // 此情况处理具体请看博客：http://www.jianshu.com/p/3a75d7348843
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    
    if(![self hh_externalAppRequiredToOpenURL:url]){
        if (!navigationAction.targetFrame) {
            [self hh_web_loadURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }else if([[UIApplication sharedApplication] canOpenURL:url]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// MARK: - 在响应完成时，调用的方法。如果设置为不允许响应， web 内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// MARK: - 接收到服务器重定向之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// MARK: - WKNavigationDelegate
// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.hh_web_didStartBlock) {
        self.hh_web_didStartBlock(webView, navigation);
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (self.hh_web_didCommitBlock) {
        self.hh_web_didCommitBlock(webView, navigation);
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.hh_web_didFinishBlock) {
        self.hh_web_didFinishBlock(webView, navigation);
    }
    
    NSString *heightString = @"document.body.scrollHeight";
    
    if (self.hh_web_getCurrentHeightBlock && !self.hh_web_isAutoHeight) {
        // webView高度自适应
        [self hh_web_stringByEvaluateJavaScript:heightString completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            self.hh_web_getCurrentHeightBlock([result doubleValue]);
        }];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.hh_web_didFailBlock) {
        self.hh_web_didFailBlock(webView, navigation);
    }
}

// MARK: - Public method
/**
 *  返回上一级页面
 */
- (void)hh_web_goBack {
    if (self.canGoBack) {
        [self goBack];
    }
}

/**
 * 进入下一级页面
 */
- (void)hh_web_goForward {
    if (self.canGoForward) {
        [self goForward];
    }
}

/**
 * 刷新 webView
 */
- (void)hh_web_reload {
    [self reload];
}

/**
 * 加载一个 webView
 * @param request 请求的 NSURL URLRequest
 */
- (void)hh_web_loadRequest:(NSURLRequest *)request {
    [self loadRequest:request];
}


/**
* 加载一个 webView
* @param URL 请求的 URL
*/
- (void)hh_web_loadURL:(NSURL *)URL {
    [self hh_web_loadRequest:[NSURLRequest requestWithURL:URL]];
}

/**
* 加载一个 webView
* @param URLString 请求的  URLString
*/
- (void)hh_web_loadURLString:(NSString *)URLString {
    [self hh_web_loadURL:[NSURL URLWithString:URLString]];
}

/**
 * 加载本地网页 不考虑 iOS 9.0 以下的版本
 * @param htmlName 请求的本地 HTML 文件名
 */
- (void)hh_web_loadHTMLFileName:(NSString *)htmlName {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.html", htmlName] ofType:nil];
    if (htmlPath) {
       NSURL *fileURL = [NSURL fileURLWithPath:htmlPath];
       [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    }
}

/**
 * 加载本地 htmlString
 * @param  htmlString 请求的本地 htmlString
 */
- (void)hh_web_loadHTMLString:(NSString *)htmlString {
    /*! 一定要记得这一步， 要不然本地的图片加载不出来*/
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    [self loadHTMLString:htmlString baseURL:baseURL];
}

/**
 * 加载 js 字符串
 *  @param javaScriptString js 字符串
 */
- (void)hh_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    [self evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

/**
 添加 js 调用 OC， addScriptMessageHandler:name:有两个参数，第一个参数是 userContentController 的代理对象，第二个参数是 JS 里发送 postMessage 的对象。添加一个脚本消息的处理器，同时需要在 JS 中添加，      window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
 
 * @param nameArray  JS 里发送 postMessage 的对象数组，可同时添加多个对象
 */
- (void)hh_web_addScriptMessageHandlerWithNameArray:(NSArray *)nameArray {
    if ([nameArray isKindOfClass:[NSArray class]] && nameArray.count > 0) {
        [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.configuration.userContentController addScriptMessageHandler:[[HHWeakScriptMessageDelegate alloc] initWithDelegate:self] name:obj];
        }];
    }
}

// MARK: - setter / getter
+ (void)load {
    [self hh_swizzleInstanceMethod:NSSelectorFromString(@"dealloc")
                              with:@selector(hh_web_dealloc)];
}

-(void)setHh_webViewHeight:(CGFloat)hh_webViewHeight {

    [self hh_runtime_setValue:@(hh_webViewHeight) withKey:@selector(hh_webViewHeight)];
}

- (CGFloat)hh_webViewHeight {
    return [[self hh_runtime_getValueForKey:_cmd] floatValue];
}

- (void)setHh_web_isAutoHeight:(BOOL)hh_web_isAutoHeight {
    [self hh_runtime_setValue:@(hh_web_isAutoHeight) withKey:@selector(hh_web_isAutoHeight)];
    if (hh_web_isAutoHeight) {
        // 监听高度变化
        [self.scrollView addObserver:self
                          forKeyPath:kHHKit_WK_contentSize
                             options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (BOOL)hh_web_isAutoHeight {
    return [[self hh_runtime_getValueForKey:_cmd] boolValue];
}

- (BOOL)hh_web_canGoBack {
    return [self canGoBack];
}

- (BOOL)hh_web_canGoForward {
    return [self canGoForward];
}

- (void)setHh_web_didStartBlock:(HHKit_webView_didStartProvisionalNavigationBlock)hh_web_didStartBlock {
    [self hh_runtime_setCopyValue:hh_web_didStartBlock withKey:@selector(hh_web_didStartBlock)];
}

- (HHKit_webView_didStartProvisionalNavigationBlock)hh_web_didStartBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_didCommitBlock:(HHKit_webView_didCommitNavigationBlock)hh_web_didCommitBlock {
    [self hh_runtime_setCopyValue:hh_web_didCommitBlock withKey:@selector(hh_web_didCommitBlock)];
}

- (HHKit_webView_didCommitNavigationBlock)hh_web_didCommitBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_didFinishBlock:(HHKit_webView_didFinishNavigationBlock)hh_web_didFinishBlock {
    [self hh_runtime_setCopyValue:hh_web_didFinishBlock withKey:@selector(hh_web_didFinishBlock)];
}

- (HHKit_webView_didFinishNavigationBlock)hh_web_didFinishBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_didFailBlock:(HHKit_webView_didFailProvisionalNavigationBlock)hh_web_didFailBlock {
    [self hh_runtime_setCopyValue:hh_web_didFailBlock withKey:@selector(hh_web_didFailBlock)];
}

- (HHKit_webView_didFailProvisionalNavigationBlock)hh_web_didFailBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_isLoadingBlock:(HHKit_webView_isLoadingBlock)hh_web_isLoadingBlock {
    [self hh_runtime_setCopyValue:hh_web_isLoadingBlock withKey:@selector(hh_web_isLoadingBlock)];
}

- (HHKit_webView_isLoadingBlock)hh_web_isLoadingBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_getTitleBlock:(HHKit_webView_getTitleBlock)hh_web_getTitleBlock {
    [self hh_runtime_setCopyValue:hh_web_getTitleBlock withKey:@selector(hh_web_getTitleBlock)];
}

- (HHKit_webView_getTitleBlock)hh_web_getTitleBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_userContentControllerDidReceiveScriptMessageBlock:(HHKit_webView_userContentControllerDidReceiveScriptMessageBlock)hh_web_userContentControllerDidReceiveScriptMessageBlock {
    [self hh_runtime_setCopyValue:hh_web_userContentControllerDidReceiveScriptMessageBlock withKey:@selector(hh_web_userContentControllerDidReceiveScriptMessageBlock)];
}

- (HHKit_webView_userContentControllerDidReceiveScriptMessageBlock)hh_web_userContentControllerDidReceiveScriptMessageBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_decidePolicyForNavigationActionBlock:(HHKit_webView_decidePolicyForNavigationActionBlock)hh_web_decidePolicyForNavigationActionBlock {
    [self hh_runtime_setCopyValue:hh_web_decidePolicyForNavigationActionBlock withKey:@selector(hh_web_decidePolicyForNavigationActionBlock)];
}

- (HHKit_webView_decidePolicyForNavigationActionBlock)hh_web_decidePolicyForNavigationActionBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_getCurrentUrlBlock:(HHKit_webView_getCurrentUrlBlock)hh_web_getCurrentUrlBlock {
    [self hh_runtime_setCopyValue:hh_web_getCurrentUrlBlock withKey:@selector(hh_web_getCurrentUrlBlock)];
}

- (HHKit_webView_getCurrentUrlBlock)hh_web_getCurrentUrlBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_getCurrentHeightBlock:(HHKit_webView_getCurrentHeightBlock)hh_web_getCurrentHeightBlock {
    [self hh_runtime_setCopyValue:hh_web_getCurrentHeightBlock withKey:@selector(hh_web_getCurrentHeightBlock)];
}

- (HHKit_webView_getCurrentHeightBlock)hh_web_getCurrentHeightBlock {
    return [self hh_runtime_getValueForKey:_cmd];
}

- (void)setHh_web_urlScheme:(NSString *)hh_web_urlScheme {
    [self hh_runtime_setValue:hh_web_urlScheme withKey:@selector(hh_web_urlScheme)];
}

- (NSString *)hh_web_urlScheme {
    return [self hh_runtime_getValueForKey:_cmd];
}

@end


