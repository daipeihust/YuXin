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
#import "MJRefreshNormalHeader.h"
#import "UserHelper.h"


@interface DPBoardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) DPBoardType boardType;
@property (nonatomic, strong) NSMutableArray *boardArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) WSProgressHUD *hud;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigViews

- (void)initView {
    self.view.backgroundColor = DPBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.retryButton];
    [self.view addSubview:self.hud];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
        [[UserHelper sharedInstance] getFavourateBoardWithCompletion:^(NSString *error, NSArray *models) {
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:models];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD safeShowString:error];
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
                    [WSProgressHUD safeShowString:error];
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
    [self.hud show];
    [self.view setUserInteractionEnabled:NO];
    __weak typeof(self) weakSelf = self;
    if (self.boardType == DPBoardTypeFavourate) {
        [[UserHelper sharedInstance] getFavourateBoardWithCompletion:^(NSString *error, NSArray *models) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.hud dismiss];
                [weakSelf.view setUserInteractionEnabled:YES];
            });
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:models];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tableView.hidden = NO;
                    [weakSelf.tableView reloadData];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD safeShowString:error];
                    weakSelf.retryButton.hidden = NO;
                });
            }
        }];
    }else {
        [[YuXinSDK sharedInstance] fetchSubboard:(YuXinBoardType)self.boardType completion:^(NSString *error, NSArray *responseModels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.hud dismiss];
                [weakSelf.view setUserInteractionEnabled:YES];
            });
            if (!error) {
                weakSelf.boardArray = [NSMutableArray arrayWithArray:responseModels];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tableView.hidden = NO;
                    [weakSelf.tableView reloadData];
                    
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [WSProgressHUD safeShowString:error];
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

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    YuXinBoard *board = self.boardArray[indexPath.row];
    UITableViewRowAction *action;
    if (self.boardType == DPBoardTypeFavourate) {
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消订阅" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [tableView setEditing:NO animated:YES];
            [[YuXinSDK sharedInstance] delFavourateBoard:board.boardName completion:^(NSString *error, NSArray *responseModels) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [WSProgressHUD safeShowString:error];
                    });
                }else {
                    [[UserHelper sharedInstance] refreshFavourateBoard];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [WSProgressHUD safeShowString:@"取消订阅成功"];
                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    });
                }
            }];
        }];
    }else {
        if ([[UserHelper sharedInstance].favourateBoard containsObject:board.boardName]) {
            action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消订阅" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [tableView setEditing:NO animated:YES];
                [[YuXinSDK sharedInstance] delFavourateBoard:board.boardName completion:^(NSString *error, NSArray *responseModels) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [WSProgressHUD safeShowString:error];
                        });
                    }else {
                        [[UserHelper sharedInstance] refreshFavourateBoard];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [WSProgressHUD safeShowString:@"取消订阅成功"];
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    }
                }];
            }];
        }else {
            action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"订阅" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [tableView setEditing:NO animated:YES];
                [[YuXinSDK sharedInstance] addFavourateBoard:board.boardName completion:^(NSString *error, NSArray *responseModels) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [WSProgressHUD safeShowString:error];
                        });
                    }else {
                        [[UserHelper sharedInstance] refreshFavourateBoard];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [WSProgressHUD safeShowString:@"订阅成功"];
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        });
                    }
                }];
            }];
        }
    }
    
    return @[action];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = DPBackgroundColor;
        _tableView.hidden = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[DPBoardCell class] forCellReuseIdentifier:DPBoardCellReuseIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        header.automaticallyChangeAlpha = YES;
        [header setTitle:@"玩命加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
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

- (WSProgressHUD *)hud {
    if (!_hud) {
        _hud = [[WSProgressHUD alloc] initWithView:self.view];
        [_hud setProgressHUDIndicatorStyle:WSProgressHUDIndicatorMMSpinner];
    }
    return _hud;
}

@end
