//
//  DPProfileViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPProfileViewController.h"
#import "DPProfileCell.h"
#import "DPProfileItem.h"
#import "UserHelper.h"
#import "WSProgressHUD+DPExtension.h"
#import "DPFriendListViewController.h"
#import "DPUserInfoViewController.h"

@interface DPProfileViewController () <UITableViewDelegate, UITableViewDataSource, DPProfileCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WSProgressHUD *hud;

@end

@implementation DPProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileVCDidAppear)]) {
        [self.delegate profileVCDidAppear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileVCDidDisappear)]) {
        [self.delegate profileVCDidDisappear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileVCWillDisappear)]) {
        [self.delegate profileVCWillDisappear];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigView

- (void)initView {
    self.title = @"用户";
    [self.view setBackgroundColor:DPBackgroundColor];
    [self.tableView setBackgroundColor:DPBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.hud];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Action Method

- (void)logout {
    [self.view setUserInteractionEnabled:NO];
    [self.hud show];
    [[UserHelper sharedInstance] logoutWithCompletion:^(NSString *message) {
        [self.view setUserInteractionEnabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud dismiss];
            [WSProgressHUD safeShowString:message];
        });
    }];
}

#pragma mark - DPProfileCellDelegate

- (void)switchChangeTo:(BOOL)state atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        [UserHelper sharedInstance].autoLogin = state;
    }
    else {
        [UserHelper sharedInstance].showColorfulText = state;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight;
    if (indexPath.section == 0) {
        rowHeight = 80.f;
    }else {
        rowHeight = 44.f;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            DPUserInfoViewController *viewController = [[DPUserInfoViewController alloc] initWithUserID:[UserHelper sharedInstance].userName];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 1: {
            DPFriendListViewController *vc = [[DPFriendListViewController alloc] initWithFriends:[[UserHelper sharedInstance] friendList]];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
            [self logout];
            break;
            
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return NO;
    }else {
        return YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return DPProfileTableViewHeaderHeight * 2;
    }
    return DPProfileTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DPProfileTableViewFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    UIView *seprationLine1 = [[UIView alloc] init];
    seprationLine1.backgroundColor = DPSeparationLineColor;
    [sectionHeaderView addSubview:seprationLine1];
    [seprationLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(sectionHeaderView);
        make.height.mas_equalTo(0.1);
    }];
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionFooterView = [[UIView alloc] init];
    sectionFooterView.backgroundColor = [UIColor clearColor];
    UIView *seprationLine2 = [[UIView alloc] init];
    seprationLine2.backgroundColor = DPSeparationLineColor;
    [sectionFooterView addSubview:seprationLine2];
    [seprationLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(sectionFooterView);
        make.height.mas_equalTo(0.1);
    }];
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPProfileCell *cell;
    DPProfileItem *item = [[DPProfileItem alloc] init];
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:DPProfileUserCellReuseIdentifier];
            item.title1 = [UserHelper sharedInstance].userName;
            item.title2 = [UserHelper sharedInstance].userInfo.experienceDescription;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:DPProfileNormalCellReuseIdentifier];
            item.title1 = @"好友";
            item.title2 = [NSString stringWithFormat:@"%i", [UserHelper sharedInstance].friendList.count];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:DPProfileSwitchCellReuseIdentifier];
            if (indexPath.row == 0) {
                item.title1 = @"自动登录";
                item.title2 = [UserHelper sharedInstance].autoLogin? @"On" : @"Off";
            }else {
                item.title1 = @"显示彩色文字";
                item.title2 = [UserHelper sharedInstance].showColorfulText? @"On" : @"Off";
            }
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:DPProfileNormalCellReuseIdentifier];
            if (indexPath.row == 0) {
                item.title1 = @"关于";
            }else {
                item.title1 = @"反馈";
            }
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:DPProfileNormalCellReuseIdentifier];
            item.title1 = @"Logout";
            break;
        default:
            break;
    }
    [cell fillDataWith:item indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DPProfileCell class] forCellReuseIdentifier:DPProfileUserCellReuseIdentifier];
        [_tableView registerClass:[DPProfileCell class] forCellReuseIdentifier:DPProfileNormalCellReuseIdentifier];
        [_tableView registerClass:[DPProfileCell class] forCellReuseIdentifier:DPProfileSwitchCellReuseIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

- (WSProgressHUD *)hud {
    if (!_hud) {
        _hud = [[WSProgressHUD alloc] initWithView:self.view];
        [_hud setProgressHUDIndicatorStyle:WSProgressHUDIndicatorMMSpinner];
    }
    return _hud;
}

@end
