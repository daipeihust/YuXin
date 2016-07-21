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
#import "UITableView+FDTemplateLayoutCell.h"
#import "WSProgressHUD+DPExtension.h"


typedef NS_ENUM(NSUInteger, DPArticleType) {
    DPArticleTypeDetail = 0,
    DPArticleTypeComment = 1
};

@interface DPArticleDetailViewController() <UITableViewDelegate, UITableViewDataSource, DPArticleDetailCellDelegate>

@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleArray;
@property (nonatomic, strong) UIButton *retryButton;

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
    [self initData];
}


#pragma mark - ConfigUI

- (void)ConfigViews {
    self.view.backgroundColor = DPBackgroundColor;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.retryButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];
    [self.view addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - DPArticleDetailCellDelegate

- (void)userImageViewDidClick:(NSString *)userID {
    NSLog(@"user image clicked: %@", userID);
}

- (void)reprintButtonDidClick:(NSString *)fileName {
    
}

- (void)commentButtonDidClick {
    
}

- (void)replyButtonDidClick {
    
}

- (void)deleteButtonDidClick:(NSString *)fileName {
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DPArticleTypeDetail) {
        return [tableView fd_heightForCellWithIdentifier:DPArticleDetailCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell fillDataWithModel:self.articleArray[indexPath.row + indexPath.section]];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:DPArticleDetailCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell fillDataWithModel:self.articleArray[indexPath.row + indexPath.section]];
        }];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
    cell.delegate = self;
    return cell;
}

#pragma mark - Privite Method


#pragma mark - Action Method

- (void)headerRefresh {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticlesWithBoard:self.boardName file:self.fileName completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.articleArray = [NSMutableArray arrayWithArray:responseModels];
            
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

- (void)initData {
    self.retryButton.hidden = YES;
    [WSProgressHUD showWithStatus:@"玩命加载中..."];
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticlesWithBoard:self.boardName file:self.fileName completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.articleArray = [NSMutableArray arrayWithArray:responseModels];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
                [WSProgressHUD dismiss];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WSProgressHUD showErrorWithStatus:error];
                [WSProgressHUD autoDismiss];
                weakSelf.retryButton.hidden = NO;
            });
        }
    }];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.hidden = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = DPBackgroundColor;
        [_tableView registerClass:[DPArticleDetailCell class] forCellReuseIdentifier:DPArticleDetailCellReuseIdentifier];
        [_tableView registerClass:[DPArticleDetailCell class] forCellReuseIdentifier:DPArticleCommentCellReuseIdentifier];
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

@end
