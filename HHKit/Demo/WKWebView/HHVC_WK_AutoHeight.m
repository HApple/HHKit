//
//  HHVC_WK_AutoHeight.m
//  HHKit
//
//  Created by Jn.Huang on 2020/7/5.
//  Copyright © 2020 hjn. All rights reserved.
//

#import "HHVC_WK_AutoHeight.h"
#import "WKWebViewAutoHeightCell.h"

static NSString * const htmlString = @"<div class=\"sanju\">\n\t<div class=\"sanju-basic\" style=\"color: #095634;font-size:32px;\">\n\t\t<ul class=\"ul\" style=\"list-style-type: none;\">\n\t\t\t<li class=\"left\" style=\"float: left;width: 50%\"><span>| 品名：海南荔枝王</span></li>\n\t\t\t<li class=\"left\" style=\"float: left;width: 49%\"><span>| 产地：海南省海口市</span></li>\n\t\t</ul>\n\t\t<ul class=\"ul\" style=\"list-style-type: none;\">\n\t\t\t<li class=\"left\" style=\"float: left;width: 50%\"><span>| 规格：约1.5kg</span></li>\n\t\t\t<li class=\"left\" style=\"float: left;width: 49%\"><span>| 储存：冷藏保存，3天</span></li>\n\t\t</ul>\n\t\t<!-- <div class=\"left\" style=\"float: left;width: 50% \">\n\t\t\t<p><span>| 品名：海南荔枝王</span></p>\n\t\t\t<p><span>| 产地：海南省海口市</span></p>\n\t\t</div>\n\t\t<div class=\"left\" style=\"color:#095634;float: left;\">\n\t\t\t<p><span>| 规格：约1.5kg</span></p>\n\t\t\t<p><span>| 储存：冷藏保存，3天</span></p>\n\t\t</div> -->\n\t</div>\n\t<div class=\"clear\" style=\"clear: both;\"></div>\n\t<div class=\"sanju-deliver\" style=\"color: #095634;font-size:32px;\">\n\t\t<h2 class=\"center\" style=\"text-align: center\">配送须知</h2>\n\t\t<ul class=\"ul\" style=\"list-style-type: none;\">\n\t\t\t<li class=\"left\" style=\"float: left;width: 25%\"><span><img  src=\"http://demo2.zjsjtz.com/public/images/78/6d/5a/fc1bbf3c2ca6548bbd3f52b9278b58eb36ee2063.jpg?1498535322#h\" style=\"width: 30px;display: inline;\" alt=\"\" />配送武汉市</span></li>\n\t\t\t<li class=\"left\" style=\"float: left;width: 25%\"><span><img src=\"http://demo2.zjsjtz.com/public/images/7c/e6/ad/70646709af72d2dbcada14cc31ddd0d6d2435c99.jpg?1498535379#h\" style=\"width: 30px;display: inline;\" alt=\"\" />实付满88包邮</span></li>\n\t\t\t<li class=\"left\" style=\"float: left;width: 25%\"><span><img src=\"http://demo2.zjsjtz.com/public/images/6e/24/93/8134409080e4be6930f8f57fc18a84df33bca8e7.jpg?1498535414#h\" style=\"width: 30px;display: inline;\" alt=\"\" />顺丰冷链配送</span></li>\n\t\t\t<li class=\"left\" style=\"float: left;width: 24%\"><span><img src=\"http://demo2.zjsjtz.com/public/images/6e/24/93/8134409080e4be6930f8f57fc18a84df33bca8e7.jpg?1498535414#h\" style=\"width: 30px;display: inline;\" alt=\"\" />他人挺好</span></li>\n\t\t</ul>\n\t\t<ul class=\"ul\" style=\"list-style-type: none;\">\n\t\t\t<li class=\"left\" style=\"float: left;width: 50%\"><span>| 下单时间：当日18:00前</span></li>\n\t\t\t<li class=\"left\" style=\"float: left;width: 49%\"><span>| 送达时间：次日18:00前</span></li>\n\t\t</ul>\n\t</div>\n\n\t<div class=\"sanju-hint\" style=\"color: #095634;font-size:32px;padding: 5px\">\n\t\t<h2 class=\"center\" style=\"text-align: center\">温馨提示</h2>\n\t\t<p><span style=\"color:#999999;line-height: 1em\">回宿舍睡觉睡觉四岁斤斤计较。结局就是今生今世是你内心的计算机黑丝深刻见解解决问题了。我的心里只有我一个人在一起我说不会离开的背影？！一切又名海洋生物。我会好好先生？！一切皆是虚妄？一个人来看一下有没有觉得你会选择错误中国人在意我要不能说说说是什么的时候你们在家看看看看着一起我想说了我会告诉你们一个人在家好无聊呀。我想</span><span style=\"color:#999999;\"></span></p>\n\t</div>\n</div>\n";

@interface HHVC_WK_AutoHeight () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<WebViewModel*> *models;
@end

@implementation HHVC_WK_AutoHeight

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDatas];
    [self setupUI];
}

// MARK: - Datas
- (void)setupDatas {
    for(int i = 0; i < 2; i++) {
        WebViewModel *model = [WebViewModel new];
        model.contentHtml = htmlString;
        model.height = 100;
        [self.models addObject:model];
    }
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
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewModel *model = self.models[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKWebViewAutoHeightCell *cell = [WKWebViewAutoHeightCell hh_createCellWithTableView:tableView];
    WebViewModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.WebLoadFinish = ^(CGFloat cellHeight) {
        if(model.height !=  cellHeight){
            model.height = cellHeight;
            [tableView reloadData];
        }
    };
    return cell;
}

// MARK: - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
