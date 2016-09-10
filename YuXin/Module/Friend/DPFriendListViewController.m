//
//  DPFriendListViewController.m
//  YuXin
//
//  Created by Dai Pei on 2016/8/7.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPFriendListViewController.h"
#import "DPFriendListCell.h"
#import "DPUserInfoViewController.h"

@interface DPFriendListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *friendArray;

@end

@implementation DPFriendListViewController

#pragma mark - Init

- (instancetype)initWithFriends:(NSArray *)friendArray {
    self = [super init];
    if (self) {
        self.friendArray = friendArray;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友";
    self.view.backgroundColor = DPBackgroundColor;
    self.tableView.backgroundColor = DPBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YuXinFriend *friend = self.friendArray[indexPath.row];
    DPUserInfoViewController *viewController = [[DPUserInfoViewController alloc] initWithUserID:friend.userID];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:DPFriendListCellReuseIdentifier forIndexPath:indexPath];
    [cell fillDataWithModel:self.friendArray[indexPath.row]];
    return cell;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DPFriendListCell class] forCellReuseIdentifier:DPFriendListCellReuseIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

@end
