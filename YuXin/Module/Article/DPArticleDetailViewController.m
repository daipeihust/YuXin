//
//  DPArticleDetailViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleDetailViewController.h"
#import "DPArticleDetailCell.h"
#import "MJRefresh.h"


typedef NS_ENUM(NSUInteger, DPArticleType) {
    DPArticleTypeDetail = 0,
    DPArticleTypeComment = 1
};

@interface DPArticleDetailViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleArray;

@end

@implementation DPArticleDetailViewController

#pragma mark - Init

- (instancetype)initWithBoard:(NSString *)boardName file:(NSString *)fileName {
    self = [super init];
    if (self) {
        self.boardName = boardName;
        self.fileName = fileName;
        self.title = @"详情";
        self.articleArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ConfigViews];
    [self firstRefresh];
}


#pragma mark - ConfigUI

- (void)ConfigViews {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YuXinArticle *model = self.articleArray[indexPath.row + indexPath.section];
    
    return model.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber;
    switch (section) {
        case DPArticleTypeDetail:
            rowNumber = (self.articleArray.count)? 1 : 0;
            break;
        case DPArticleTypeComment:
            rowNumber = (self.articleArray.count)? self.articleArray.count - 1 : 0;
            break;
        default:
            break;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPArticleDetailCell *cell;
    switch (indexPath.section) {
        case DPArticleTypeDetail:
            cell = [tableView dequeueReusableCellWithIdentifier:DPArticleDetailCellReuseIdentifier];
            break;
        case DPArticleTypeComment:
            cell = [tableView dequeueReusableCellWithIdentifier:DPArticleCommentCellReuseIdentifier];
            break;
        default:
            break;
    }
    [cell fillDataWithModel:self.articleArray[indexPath.row + indexPath.section]];
    return cell;
}

#pragma mark - Privite Method

- (void)firstRefresh {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Action Method

- (void)headerRefresh {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticlesWithBoard:self.boardName file:self.fileName completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.articleArray = [NSMutableArray arrayWithArray:responseModels];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }
    }];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = DPBackgroundColor;
        [_tableView registerClass:[DPArticleDetailCell class] forCellReuseIdentifier:DPArticleDetailCellReuseIdentifier];
        [_tableView registerClass:[DPArticleDetailCell class] forCellReuseIdentifier:DPArticleCommentCellReuseIdentifier];
    }
    return _tableView;
}

@end
