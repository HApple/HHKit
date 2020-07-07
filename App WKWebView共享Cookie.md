### App WKWebView共享Cookie

首先说下我想要实现的效果：

当我在App登录完后，进入WKWebView在网页里也是登录的状态

当我退出登录后，进入WKWebView在网页里也是退出登录的状态



### 以一个实际流程来说明演示

App 

​     | 登录

​     [ [AFHTTPSessionManager manager]  POST: parameters: progress: success: failure]

​      |成功回调

AFHTTPSessionManager   success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success

​      |返回response

NSURLSessionDataTask   NSURLResponse *response

​      |头部

NSHTTPURLResponse     .allHeaderFields

​      |

.allHeaderFields 的内容如下

具体看"Set-Cookie"的内容，如果看不懂，请参考[这篇文章](https://github.com/HApple/HHWKWebView/wiki/详解HTTP的Cookie)

```json
{
    Connection = "keep-alive";
    "Content-Encoding" = gzip;
    "Content-Type" = "application/json;charset=UTF-8";
    Date = "Fri, 03 Jul 2020 03:42:36 GMT";
    "Set-Cookie" = "au_token=eNMamZ8-ctO6SAFWiV8pfX5eaVyeEByUlKO75uRjSTj0; Max-Age=86400; Expires=Sat, 04-Jul-2020 03:42:36 GMT; Domain=hh.com; Path=/; HttpOnly, user_id=609883478351507456;";
    "Strict-Transport-Security" = "max-age=86400";
    "Transfer-Encoding" = Identity;
    Vary = "Accept-Encoding";
}
```

"Set-Cookie" 里的内容会自动设置到

[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] 里



iOS中Cookie管理主要有两个类
      NSHTTPCookie
      NSHTTPCookieStorage
当你访问一个网站时，NSURLRequest都会帮你主动记录下来你访问的站点设置的Cookie
因为NSHTTPCookieStorage的默认策略是:NSHTTPCookieAcceptPolicyAlways,所以
如果Cookie存在的话，会把这些信息放在NSHTTPCookieStorage容器中共享，当你下次再
访问这个站点时，NSURLRequest会拿着上次保存下来了的Cookie继续去请求。



### 示例代码展示

```objective-c
//NSURLSesscionDataTask * _Nonnull task,
NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
NSDictionary *dataDict = [response.allHeaderFields mj_JSONObject];
if(dataDict[@"Set-Cookie"]) {
  //保存一份 这里保存的是NSSring JSon格式的,方便请求的时候直接设置上传
  HHUser.shared.userCookie = dataDict[@"Set-Cookie"];
  NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in [cookieStorage cookies]){
    if([cookie.name isEqualToString:@"au_token"] && [HHConfig.shared.serverUrl containsString:cookie.domain]) {
      HHUser.shared.au_token = cookie.value;
      HHUser.shared.domain = cookie.domain;
      HHUser.shared.cookieExpiresDate = [NSString stringWithFormat:@"%ld",(long)[cookie.expiresDate timeIntervalSince1970]];
      [HHWebCookieHelper addCookieForDomain:HHUser.shared.domain withName:@"app" values:@"HHApp"];
    }
  }
}


```

HHWebCookieHelper里的代码

```objective-c
+ (void)addCookieForDomain:(NSString *)domain withName:(NSString *)name values:(NSString *)value {
	NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
	[properties setValue:value forKey:NSHTTPCookieValue];
	[properties setValue:name forKey:NSHTTPCookieName];
	[properties setValue:domain forKey:NSHTTPCookieDomain];
	[properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
  [properties setValue:@"/" forKey:NSHTTPCookiePath];
  NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
  [[NSHTTPCookiesStorage sharedHTTPCookieStorage] setCookie:cookie];
}
```



HHUser.shared.userCookie的用处

这里基于AFNetworking的AFHTTPRequestSerializer设置"Set-Cookie"请求头

```objective-c
	  if (HHUser.shared.isLogin && HHUser.shared.userCookie.length > 0) {
        [self.requestSerializer setValue:HHUser.shared.userCookie forHTTPHeaderField:@"Set-Cookie"];
    }
```



 HHUser.shared.au_token的用处

用于登录验证

手势登陆后 token验证续期

手势密码验证成功后 -》 调用"user/gesture_authorize"接口上传Token验证是否过期 以及续期Token

面部登录后token验证续期

面部识别解锁成功后 -》 调用"user/finger_print_authorize"接口上传Token验证是否过期 以及续期Token



### 同步NSHTTPCookieStorage到WKWebView的WKHTTPCookieStore

iOS11以前的具体可以看[UIWebView和WKWebView的cookie管理机制](https://www.jianshu.com/p/19e100b0c674)

这里仅讨论iOS11+

简单来说WKWebView中的Cookie与App中的Cookie是独立开来的

WKWebView存储在WKHTTPCookieStore中 App存储在NSHTTPCookieStorage 中

所以WKWebView在loadRequest之前，需要将NSHTTPCookieStorage的Cookie复制到WKHTTPCookieStore中

以达到例如App登录了网页也登录的效果

示例展示

```objective-c
- (void)loadRequestUrl {
  self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLString:self.urlString]];
  //同步App与WKWebView的语言
  [self.request addValue:HHConfig.shared.languageCode forHTTPHeaderField:@"Accept-Language"];
  //如果登录 同步au_token等cookie 以保持App登录了 WKWebView也同时是登录的状态
  if(HHUser.shared.isLogin){ 
		 [self copyNSHTTPCookieStorageToWKTTPCookieStoreWithCompletionHandler:^{
        [self.wkWebView loadRequest:self.request];
     }];
  }else {
    //如果退出登录 或 未登录，也要删除对应的Cookie 以保持App退出,WKWebView也同时是退出登录的状态
    [self deleteCookieWithCompletionHandler:^{
      [self.wkWebView loadRequest:self.request];
    }];
  }
}

//同步HTTP的Cookie到WKHTTP                      
- (void)copyNSHTTPCookieStorageToWKHTTPCookieStoreWithCompletionHandler:(nullable void(^)(void))theCompletionHandler {
   NSArray *httpCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
   WKHTTPCookieStore *wkCookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
   if (cookies.count == 0) {
     !theCompletionHandler ?: theCompletionHandler();
     return;
   }
   for (NSHTTPCookie *cookie in httpCookies) {
      [wkCookieStore setCookie:cookie completionHandler:^{
         if([cookie isEqual:[cookies lastObject]])) {
           !theCompletionHandler ?: theCompletionHandler()
         } 
      }];
   }
}

//删除WKHTTP的登录Cookie
- (void)deleteCookieWithCompletionHandler:(nullable void(^)(void))theCompletionHandler {
  WKHTTPCookieStore *wkCookieStore = self.wkWebView.configuration.websiteDataStore.httpCookieStore;
  __weak typeof(self) weakSelf = self;
  [wkCookieStore getAllCookies:^(NSArray *cookies){
    dispatch_async(dispatch_get_main_queue(), ^{
      NSMutableArray *toBeDeleteCookies = [NSMutableArray array];
      for(NSHTTPCookie *cookie in cookies) {
        //这里根据实际需求 删除对应的登录cookie 
        if([cookie.name isEqualToString:@"user_id"] || [cookie.name isEqualToString:@"au_token"]) {
          [toBeDeleteCookies addObject:cookie];
        }
      }
      for(NSHTTPCookie *cookie in toBeDeleteCookies){
        [wkCookieStore deleteCookie:cookie completionHandler:^{
          if([cookie isEqual:[toBeDeleteCookies lastObject]]){
            !completionHandler ?: completionHandler()
          }
        }];
      }
    })
  }];
}
```



### 如果我先在WKWebView登录呢

同样的，WKHTTPCookieStore不会自动同步到NSHTTPCookieStorage，还是需要手动copy同步

这里看项目实际需求，如果需要同步，那就是反向过程，这里不再赘述



### 结尾

上面代码都是片段的，实际的看我项目中的代码，会封装好便于调用。