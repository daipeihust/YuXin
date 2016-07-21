//
//  DPArticleTitleViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleTitleViewController.h"
#import "DPArticleTitleCell.h"
#import "MJRefresh.h"
#import "DPArticleDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "WSProgressHUD+DPExtension.h"

@interface DPArticleTitleViewController() <UITableViewDelegate, UITableViewDataSource, DPArticleTitleCellDelegate>

@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation DPArticleTitleViewController

#pragma mark - Init

- (instancetype)initWithBoardName:(NSString *)boardName {
    self = [super init];
    if (self) {
        self.boardName = boardName;
        self.title = boardName;
        self.titleArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - ConfigViews

- (void)configUI {
    self.view.backgroundColor = DPBackgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.retryButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Privite Method

- (void)firstRefresh {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Action Method

- (void)headerRefresh {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticleTitleListWithBoard:self.boardName start:@(0) completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.titleArray = [NSMutableArray arrayWithArray:responseModels];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WSProgressHUD showErrorWithStatus:error];
                [WSProgressHUD autoDismiss];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}

- (void)footerRefresh {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticleTitleListWithBoard:self.boardName start:@(self.titleArray.count) completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            [weakSelf.titleArray addObjectsFromArray:responseModels];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WSProgressHUD showErrorWithStatus:error];
                [WSProgressHUD autoDismiss];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)initData {
    self.retryButton.hidden = YES;
    [WSProgressHUD showWithStatus:@"玩命加载中..."];
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticleTitleListWithBoard:self.boardName start:@(0) completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.titleArray = [NSMutableArray arrayWithArray:responseModels];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
                [WSProgressHUD dismiss];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.retryButton.hidden = NO;
                [WSProgressHUD showErrorWithStatus:error];
                [WSProgressHUD autoDismiss];
            });
        }
    }];
}

#pragma mark - DPArticleTitleCellDelegate

- (void)userImageViewDidClick:(NSString *)userID {
    NSLog(@"user image clicked: %@", userID);
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:DPArticleTitleCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell fillDataWithModel:weakSelf.titleArray[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YuXinTitle *title = self.titleArray[indexPath.row];
    DPArticleDetailViewController *viewController = [[DPArticleDetailViewController alloc] initWithBoard:self.boardName file:title.fileName];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DPArticleTitleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DPArticleTitleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DPArticleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:DPArticleTitleCellReuseIdentifier];
    [cell fillDataWithModel:self.titleArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        _tableView.backgroundColor = DPBackgroundColor;
        [_tableView registerClass:[DPArticleTitleCell class] forCellReuseIdentifier:DPArticleTitleCellReuseIdentifier];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        header.automaticallyChangeAlpha = YES;
        [header setTitle:@"玩命加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        footer.automaticallyChangeAlpha = YES;
        [footer setTitle:@"玩命加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

- (UIButton *)retryButton {
    if(!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _retryButton.hidden = YES;
        [_retryButton setTitle:@"retry" forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(initData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

@end
