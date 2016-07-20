//
//  DPBoardViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPBoardViewController.h"
#import "DPBoardCell.h"
#import "YuXinSDK.h"
#import "WSProgressHUD+DPExtension.h"
#import "MJRefresh.h"
#import "DPArticleTitleViewController.h"

@interface DPBoardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) DPBoardType boardType;
@property (nonatomic, strong) NSMutableArray *boardArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation DPBoardViewController

#pragma mark - Init

- (instancetype)initWithBoardType:(DPBoardType)boardType {
    self = [super init];
    if (self) {
        self.boardType = boardType;
        self.boardArray = [NSMutableArray array];
        self.title = @"Board";
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigViews

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
}


#pragma mark - Action Method

- (void)headerRefresh {
    __weak typeof(self) weakSelf = self;
    if (self.boardType == DPBoardTypeFavourate) {
        [[YuXinSDK sharedInstance] fetchFavourateBoardWithCompletion:^(NSString *error, NSArray *responseModels) {
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:responseModels];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD showImage:nil status:error];
                    [WSProgressHUD autoDismiss];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }];
    }else {
        [[YuXinSDK sharedInstance] fetchSubboard:(YuXinBoardType)self.boardType completion:^(NSString *error, NSArray *responseModels) {
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:responseModels];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD showImage:nil status:error];
                    [WSProgressHUD autoDismiss];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }];
    }
}

#pragma mark - Privite Method

- (void)initData {
    self.retryButton.hidden = YES;
    [WSProgressHUD showShimmeringString:@"玩命加载中..."];
    __weak typeof(self) weakSelf = self;
    if (self.boardType == DPBoardTypeFavourate) {
        [[YuXinSDK sharedInstance] fetchFavourateBoardWithCompletion:^(NSString *error, NSArray *responseModels) {
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:responseModels];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tableView.hidden = NO;
                    [weakSelf.tableView reloadData];
                    [WSProgressHUD dismiss];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD showImage:nil status:error];
                    [WSProgressHUD autoDismiss];
                    weakSelf.retryButton.hidden = NO;
                });
            }
        }];
    }else {
        [[YuXinSDK sharedInstance] fetchSubboard:(YuXinBoardType)self.boardType completion:^(NSString *error, NSArray *responseModels) {
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:responseModels];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tableView.hidden = NO;
                    [weakSelf.tableView reloadData];
                    [WSProgressHUD dismiss];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD showImage:nil status:error];
                    [WSProgressHUD autoDismiss];
                    weakSelf.retryButton.hidden = NO;
                });
            }
        }];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YuXinBoard *board = self.boardArray[indexPath.row];
    DPArticleTitleViewController *viewController = [[DPArticleTitleViewController alloc] initWithBoardName:board.boardName];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:DPBoardCellReuseIdentifier];
    [cell fileDataWithModel:self.boardArray[indexPath.row]];
    return cell;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.hidden = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[DPBoardCell class] forCellReuseIdentifier:DPBoardCellReuseIdentifier];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
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
