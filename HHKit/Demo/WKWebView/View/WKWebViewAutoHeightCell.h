//
//  WKWebViewAutoHeightCell.h
//  HHKit
//
//  Created by Jn.Huang on 2020/7/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHKit_WekView.h"
#import "WebViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewAutoHeightCell : UITableViewCell

@property (nonatomic, strong) WebViewModel *model;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) void(^WebLoadFinish)(CGFloat cellHeight);

+ (instancetype)hh_createCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
