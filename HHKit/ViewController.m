//
//  ViewController.m
//  HHKit
//
//  Created by MeiZan_iMac2019 on 2020/4/1.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "ViewController.h"
#import "HHKit.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *classNames;
@property (nonatomic, strong)NSMutableArray *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDatas];
    [self setupUI];
}

// MARK: - Datas
- (void)setupDatas {
    [self addTitle:@"UITextField" withClassName:@"HHVC_TextField"];
    [self addTitle:@"WKWebView" withClassName:@"HHVC_WKWebView"];
    [self addTitle:@"HHNetManager" withClassName:@"HHVC_HHNet"];
}

- (void)addTitle:(NSString *)title withClassName:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
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
    return self.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell hh_cellIdentify] forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class)
    {
        UIViewController *vc = class.new;
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

// MARK: - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell hh_cellIdentify]];
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

- (NSMutableArray *)classNames {
    if (!_classNames) {
        _classNames = [NSMutableArray array];
    }
    return _classNames;
}
@end
