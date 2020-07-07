//
//  WKWebViewAutoHeightCell.m
//  HHKit
//
//  Created by Jn.Huang on 2020/7/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "WKWebViewAutoHeightCell.h"

static NSString * const kCellID = @"WKWebViewAutoHeightCell";

@implementation WKWebViewAutoHeightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

+ (instancetype)hh_createCellWithTableView:(UITableView *)tableView {
    WKWebViewAutoHeightCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    return cell;
}

- (void)setupUI {
    [self.contentView addSubview:self.webView];
}

- (void)setModel:(WebViewModel *)model {
    _model = model;
    if (self.model.height == 100) {
        [self.webView hh_web_loadHTMLString:self.model.contentHtml];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.hh_web_isAutoHeight = YES;
        //添加WKWebView的代理，注意：用此方法添加代理
        [_webView hh_web_initWithDelegate:_webView uiDelegate:_webView];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.userInteractionEnabled = NO;
        HH_WeakSelf
        _webView.hh_web_getCurrentHeightBlock = ^(CGFloat currentHeight) {
            HH_StrongSelf
            self.cellHeight = currentHeight;
            if (self.WebLoadFinish) {
                self.WebLoadFinish(self.cellHeight);
            }
        };
    }
    return _webView;
}

@end
