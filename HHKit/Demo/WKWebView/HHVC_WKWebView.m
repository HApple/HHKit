//
//  HHVC_WKWebView.m
//  HHKit
//
//  Created by Jn.Huang on 2020/7/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHVC_WKWebView.h"
#import "HHKit_WekView.h"
#import "HHVC_WK_OC_JS.h"
#import "HHVC_WK_AutoHeight.h"

static NSString *const kHHVC_WKWebView_CellIdentify = @"kHHVC_WKWebView_CellIdentify";

@interface HHVC_WKWebView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titles;
@end

@implementation HHVC_WKWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDatas];
    [self setupUI];
}

// MARK: - Datas
- (void)setupDatas {
    [self.titles addObject:@"加载普通 URL"];
    [self.titles addObject:@"加载 后台返回的 htmlString"];
    [self.titles addObject:@"加载自定义 request"];
    [self.titles addObject:@"加载本地 HTML 文件"];
    [self.titles addObject:@"OC JS互调"];
    [self.titles addObject:@"cell 中添加 html"];
}

// MARK: - UI
- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

// MARK: - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHHVC_WKWebView_CellIdentify forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = self.titles[indexPath.row];
    switch (indexPath.row) {
        case 0: {
            HHWebViewController *webVc = [HHWebViewController new];
            webVc.hh_web_progressTintColor = [UIColor systemYellowColor];
            webVc.hh_web_progressTrackTintColor = [UIColor whiteColor];
            [webVc hh_web_loadURLString:@"https://hbtc.zendesk.com/hc/zh-cn/articles/360050483354"];
            [self.navigationController pushViewController:webVc animated:YES];
        }
            break;
        case 1: {
            NSString *headStr = @"<head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0,minimum-scale=1.0, user-scalable=no\" /><style>img{width:100% !important}</style></head>";
            NSString *image = [NSString stringWithFormat:@"<div style=\"margin: -8px -8px;\"><img src='%@'/></div>",@"https://img9.doubanio.com/view/photo/l/public/p616745875.jpg"];
            NSString *contentStr = @"教父三部曲";
            NSString *htmlStr = [NSString stringWithFormat:@"<!DOCTYPE html><html>%@<body style='background-color:#ffffff'>%@<br><div style=\"margin: 15px 15px;\">%@</div></body></html>",headStr,image,contentStr];
            HHWebViewController *webVc = [HHWebViewController new];
            [webVc hh_web_loadHTMLString:htmlStr];
            [self.navigationController pushViewController:webVc animated:YES];
        }
            break;
        case 2: {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"HHTestWebLoadRequest" withExtension:@"html"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            HHWebViewController *webVc = [HHWebViewController new];
            webVc.title = title;
            [webVc hh_web_loadRequest:request];
            [self.navigationController pushViewController:webVc animated:YES];
        }
            break;
        case 3:{
            HHWebViewController *webVc = [HHWebViewController new];
            webVc.title = title;
            [webVc hh_web_loadHTMLFileName:@"HHTestWebLoadRequest"];
            [self.navigationController pushViewController:webVc animated:YES];
        }
            break;
        case 4: {
            HHVC_WK_OC_JS *vc = [HHVC_WK_OC_JS new];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5: {
            
            HHVC_WK_AutoHeight *webVc = [HHVC_WK_AutoHeight new];
            webVc.title = title;
            [self.navigationController pushViewController:webVc animated:YES];

        }
            break;
        default:
            break;
    }
}

// MARK: - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHHVC_WKWebView_CellIdentify];
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}
@end
