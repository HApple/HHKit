//
//  HHWebViewController.m
//  HHKit
//
//  Created by Jn.Huang on 2020/7/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHWebViewController.h"
#import "HHKit_WekView.h"

@interface HHWebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *webConfig;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSURL *hh_web_currentUrl;

@end

@implementation HHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self handleTheWebviewOfLoadProgress];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configBackItem];
    [self configMenuItem];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(0, self.webView.scrollView.adjustedContentInset.top, self.view.frame.size.width, 2);
}

- (void)handleTheWebviewOfLoadProgress {
    
    HH_WeakSelf
    self.webView.hh_web_didStartBlock = ^(WKWebView * _Nullable webView, WKNavigation * _Nonnull navigation) {
        HHLog(@"网页开始加载");
    };
    
    self.webView.hh_web_isLoadingBlock = ^(BOOL isLoading, CGFloat progress) {
        HH_StrongSelf
        HHLog(@"网页正在加载 progress %f",progress);
        [self hh_web_progressShow:progress];
    };
    
    self.webView.hh_web_didFinishBlock = ^(WKWebView * _Nonnull webView, WKNavigation * _Nonnull navigation) {
        HH_StrongSelf
        HHLog(@"网页结束加载");
        if (self.navigationItem.leftBarButtonItems.count == 1)
        {
            [self configCloseItem];
        }
        
        // WKWebView 禁止长按（超链接、图片、文本...）弹出效果
        [self hh_web_stringByEvaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    };
    
    self.webView.hh_web_getTitleBlock = ^(NSString * _Nonnull title) {
        HH_StrongSelf
        HHLog(@"获取当前网页的 title %@",title);
        self.title = title;
    };
    
    self.webView.hh_web_getCurrentUrlBlock = ^(NSURL * _Nonnull currentUrl) {
        HH_StrongSelf
        HHLog(@"获取当前加载的Url %@",currentUrl);
        self.hh_web_currentUrl = currentUrl;
    };
}

//MARK: - public Method
- (void)hh_web_loadRequest:(NSURLRequest *)request
{
    [self.webView hh_web_loadRequest:request];
}

- (void)hh_web_loadURL:(NSURL *)URL
{
    [self.webView hh_web_loadURL:URL];
}

- (void)hh_web_loadURLString:(NSString *)URLString
{
    [self.webView hh_web_loadURLString:URLString];
}

- (void)hh_web_loadHTMLFileName:(NSString *)htmlName
{
    [self.webView hh_web_loadHTMLFileName:htmlName];
}

- (void)hh_web_loadHTMLString:(NSString *)htmlString
{
    [self.webView hh_web_loadHTMLString:htmlString];
}

- (void)hh_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self.webView hh_web_stringByEvaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

- (void)setHh_web_progressTintColor:(UIColor *)hh_web_progressTintColor {
    _hh_web_progressTintColor = hh_web_progressTintColor;
    self.progressView.progressTintColor = hh_web_progressTintColor;
}

- (void)setHh_web_progressTrackTintColor:(UIColor *)hh_web_progressTrackTintColor {
    _hh_web_progressTrackTintColor = hh_web_progressTrackTintColor;
    self.progressView.trackTintColor = hh_web_progressTrackTintColor;
}

//MARK: - custom Method
//导航栏的返回按钮
- (void)configBackItem {
    
    UIImage *backImage = [UIImage imageNamed:@"HHKit_WebView.bundle/navigationbar_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = closeItem;
    
}

//导航栏的菜单按钮
- (void)configMenuItem {
    UIImage *menuImage = [UIImage imageNamed:@"HHKit_WebView.bundle/navigationbar_more"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] init];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn sizeToFit];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}

// 导航栏的关闭按钮
- (void)configCloseItem {
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,closeItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

- (void)hh_web_progressShow:(CGFloat)progress {
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
    self.progressView.progress = progress;
    if (progress == 1.0f) {
        [self hh_web_progressHidden];
    }
}

- (void)hh_web_progressHidden {
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.2f);
    } completion:^(BOOL finished) {
        self.progressView.hidden = YES;
    }];
}

//MARK: - Touch Event
- (void)backBtnAction:(UIButton *)sender {
    if (self.webView.hh_web_canGoBack) {
        [self.webView hh_web_goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)menuBtnAction:(UIButton *)sender {
    
}

- (void)closeBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
 
// MARK: - Setter/Getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        // 添加 WKWebView 的代理 注意：用此方法添加代理
        [_webView hh_web_initWithDelegate:_webView uiDelegate:_webView];
        _webView.hh_web_isAutoHeight = NO;
        _webView.multipleTouchEnabled = YES;
        _webView.autoresizesSubviews = YES;
     }
    return _webView;
}

- (WKWebViewConfiguration *)webConfig {
    /**
     1.WKWebViewConfiguration: 是WKWebView初始化时的配置类，里面存放着初始化WKWebView的一系列属性
     2.WKUserContentController: 为JS提供了一个发送消息的通道并且可以向页面注入JS的类 WKUserContentController 对象可以添加多个scriptMessageHandler
     3.addScriptMessageHandler:name:有两个参数 第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。
       添加一个脚本消息的处理器,需要同时在JS添加 window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用
     **/
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.allowsInlineMediaPlayback = YES;
        
        /**
         通过 JS 与 WKWebView 内容交互
         注入 JS对象名称 senderModel，当 JS 通过 senderModel 来调用时， 我们可以在 WKScriptMessageHandler 代理中接收到
         */
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        _webConfig.userContentController = userContentController;
        
        // 初始化偏好设置属性：preferences
        _webConfig.preferences = [WKPreferences new];
        // The minimum font size in points default is 0
        _webConfig.preferences.minimumFontSize = 15;
        
        
        
    }
    return _webConfig;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}
@end
