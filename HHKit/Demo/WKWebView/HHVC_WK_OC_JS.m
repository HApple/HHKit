//
//  HHVC_WK_OC_JS.m
//  HHKit
//
//  Created by Jn.Huang on 2020/7/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHVC_WK_OC_JS.h"
#import "HHKit_WekView.h"

#define HHKit_ShowAlertWithMsg(msg) UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确 定" style:UIAlertActionStyleDefault handler:nil];\
[alert addAction:sureAction];\
[self presentViewController:alert animated:YES completion:nil];

@interface HHVC_WK_OC_JS ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *ocInvokeJSBtn;

@end

@implementation HHVC_WK_OC_JS

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.webView hh_web_loadHTMLFileName:@"HHTestOCJS"];
    [self hh_JS_OC];
    [self hh_OC_JS];
}

- (void)setupUI {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.ocInvokeJSBtn];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0, 0, self.view.width, self.view.height-75);
    self.ocInvokeJSBtn.frame = CGRectMake(0, self.view.height - 75, self.view.width, 75);
}

//MARK:- JS_OC
- (void)hh_JS_OC {
    // 1.先注册ID
    NSArray *messageNameArray = @[@"HH_JS_OC_Alert",@"HH_JS_OC_JumpVC",@"HH_OC_JS__JS_OC_SendMsg"];
    [self.webView hh_web_addScriptMessageHandlerWithNameArray:messageNameArray];
    
    // 2. JS调用OC时 webView会调用此 block
    HH_WeakSelf
    self.webView.hh_web_userContentControllerDidReceiveScriptMessageBlock = ^(WKUserContentController * _Nonnull userContentController, WKScriptMessage * _Nonnull message) {
        HH_StrongSelf
        if ([message.name isEqualToString:messageNameArray[0]]){
            HHKit_ShowAlertWithMsg(@"OC Alert");
        }else if([message.name isEqualToString:messageNameArray[1]]){
            UIViewController *vc = [UIViewController new];
            vc.title = @"这里是 JS 按钮跳转的 VC";
            [self.navigationController pushViewController:vc animated:YES];
        }else if([message.name isEqualToString:messageNameArray[2]]){
            NSArray *array = message.body;
            NSString *msg = [NSString stringWithFormat:@"%@\n%@",array[0],array[1]];
            HHKit_ShowAlertWithMsg(msg);
        }
        
    };
}

//MARK: - OC_JS OC拦截 JS URL处理
- (void)hh_OC_JS {
    HH_WeakSelf
    // 必须要先设定 要拦截的 urlScheme, 然后再处理回调
    self.webView.hh_web_urlScheme = @"hhsharefunction";
    self.webView.hh_web_decidePolicyForNavigationActionBlock = ^(NSURL * _Nonnull currentUrl) {
        HH_StrongSelf
        // 判断 host 是否对应，然后做相应处理
        if ([currentUrl.host isEqualToString:@"shareClick"]) {
            // 拦截到 URL 中的分享内容
            [self hh_shareClickWithUrl:currentUrl];
        }else if([currentUrl.host isEqualToString:@"getLocation"]) {
            [self hh_getLocationWithUrl:currentUrl];
        }
    };
}

//MARK: - OC_JS OC 拦截 JS URL处理：1.拦截 JS 提供的分享内容，用 OC 方法处理
- (void)hh_shareClickWithUrl:(NSURL *)url {
    NSURLComponents *urlComponets = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    //url 中参数的key value
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    for(NSURLQueryItem *item in urlComponets.queryItems) {
        [parameter setObject:[item.value stringByRemovingPercentEncoding] forKey:item.name];
    }
    HHLog(@"从H5端获取的参数字典: %@", parameter);
    HHKit_ShowAlertWithMsg([parameter description]);
}

//MARK: - OC_JS OC 拦截 JS URL处理：2.拦截 JS 获取的定位信息，用 OC 方法处理
- (void)hh_getLocationWithUrl:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    for(NSURLQueryItem *item in urlComponents.queryItems) {
        [parameter setObject:[item.value stringByRemovingPercentEncoding] forKey:item.name];
    }
    HHLog(@"从H5端获取的参数字典: %@", parameter);
    HHKit_ShowAlertWithMsg([parameter description]);
}

//MARK: - OC_Invoke_JS
- (void)clickOCInvokeJSBtn {
    NSString *jsMethod = [NSString stringWithFormat:@"hh_insert('我一直都在 是你来了 又离开','OC_Invoke_JS')"];
    [self.webView hh_web_stringByEvaluateJavaScript:jsMethod completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
        HHLog(@"result %@,error %@",result,error);
    }];
}

//MARK: - Setter/Getter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        [_webView hh_web_initWithDelegate:_webView uiDelegate:_webView];
    }
    return _webView;
}

- (UIButton *)ocInvokeJSBtn {
    if (!_ocInvokeJSBtn) {
        _ocInvokeJSBtn = [UIButton new];
        [_ocInvokeJSBtn setTitle:@"OC按钮调用JS方法" forState:UIControlStateNormal];
        [_ocInvokeJSBtn setBackgroundColor:[UIColor blueColor]];
        [_ocInvokeJSBtn addTarget:self action:@selector(clickOCInvokeJSBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocInvokeJSBtn;
}
@end
