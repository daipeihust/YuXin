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
#import "UIViewController+MailComposer.h"

typedef NS_ENUM(NSUInteger, DPProfileSection) {
    DPProfileSectionOne     = 0,
    DPProfileSectionTwo     = 1,
    DPProfileSectionThree   = 2,
    DPProfileSectionFour    = 3,
    DPProfileSectionFive    = 4
};

typedef NS_ENUM(NSUInteger, DPProfileRow) {
    DPProfileRowOne     = 0,
    DPProfileRowTwo     = 1,
    DPProfileRowThree   = 2,
    DPProfileRowFour    = 3
};

static const NSUInteger rowNumOfSectionOne = 1;
static const NSUInteger rowNumOfSectionTwo = 1;
static const NSUInteger rowNumOfSectionThree = 4;
static const NSUInteger rowNumOfSectionFour = 2;
static const NSUInteger rowNumOfSectionFive = 1;

static const NSUInteger numOfSection = 5;

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

#pragma mark - DPProfileCellDelegate

- (void)switchChangeTo:(BOOL)state atIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case DPProfileRowOne:
            [UserHelper sharedInstance].autoLogin = state;
            break;
        case DPProfileRowTwo:
            [UserHelper sharedInstance].showColorfulText = state;
            break;
        case DPProfileRowThree:
            [UserHelper sharedInstance].flexibleHome = state;
            [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationFlexibleHome object:nil];
            break;
        case DPProfileRowFour:
            [UserHelper sharedInstance].showSignature = state;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight;
    if (indexPath.section == DPProfileSectionOne) {
        rowHeight = 80.f;
    }else {
        rowHeight = 44.f;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleSelect:[self itemTypeWithIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == DPProfileSectionThree) {
        return NO;
    }else {
        return YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == DPProfileSectionOne) {
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
    return numOfSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierWithIndexPath:indexPath]];
    DPProfileItem *item = [DPProfileItem itemWithType:[self itemTypeWithIndexPath:indexPath]];
    [cell fillDataWith:item indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DPProfileSectionOne:
            return rowNumOfSectionOne;
            break;
        case DPProfileSectionTwo:
            return rowNumOfSectionTwo;
            break;
        case DPProfileSectionThree:
            return rowNumOfSectionThree;
            break;
        case DPProfileSectionFour:
            return rowNumOfSectionFour;
            break;
        case DPProfileSectionFive:
            return rowNumOfSectionFive;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark - Privite Method

- (DPProfileItemType)itemTypeWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DPProfileSectionOne:
            return DPProfileItemTypeUserInfo;
            break;
        case DPProfileSectionTwo:
            return DPProfileItemTypeFriend;
            break;
        case DPProfileSectionThree:
            switch (indexPath.row) {
                case DPProfileRowOne:
                    return DPProfileItemTypeAutoLogin;
                    break;
                case DPProfileRowTwo:
                    return DPProfileItemTypeColorfulText;
                    break;
                case DPProfileRowThree:
                    return DPProfileItemTypeFlexibleHome;
                    break;
                case DPProfileRowFour:
                    return DPProfileItemTypeShowSignature;
                    break;
            }
            break;
        case DPProfileSectionFour:
            switch (indexPath.row) {
                case DPProfileRowOne:
                    return DPProfileItemTypeAboutUs;
                    break;
                case DPProfileRowTwo:
                    return DPProfileItemTypeFeedback;
                    break;
                default:
                    break;
            }
            break;
        case DPProfileSectionFive:
            return DPProfileItemTypeLogout;
            break;
    }
    return DPProfileItemNumber;
}

- (void)handleSelect:(DPProfileItemType)type {
    switch (type) {
        case DPProfileItemTypeUserInfo:
            [self showUserInfo];
            break;
        case DPProfileItemTypeFriend:
            [self showFriendVC];
            break;
        case DPProfileItemTypeAboutUs:
            [self aboutUs];
            break;
        case DPProfileItemTypeFeedback:
            [self feedback];
            break;
        case DPProfileItemTypeLogout:
            [self logout];
            break;
        default:
            break;
    }
}

- (NSString *)reuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DPProfileSectionOne:
            return DPProfileUserCellReuseIdentifier;
            break;
        case DPProfileSectionTwo:
        case DPProfileSectionFour:
        case DPProfileSectionFive:
            return DPProfileNormalCellReuseIdentifier;
            break;
        case DPProfileSectionThree:
            return DPProfileSwitchCellReuseIdentifier;
            break;
        default:
            return DPProfileNormalCellReuseIdentifier;
            break;
    }
}

#pragma mark - item handler

- (void)showUserInfo {
    DPUserInfoViewController *viewController = [[DPUserInfoViewController alloc] initWithUserID:[UserHelper sharedInstance].userName];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showFriendVC {
    DPFriendListViewController *vc = [[DPFriendListViewController alloc] initWithFriends:[[UserHelper sharedInstance] friendList]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)aboutUs {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于" message:@"本应用开源项目地址:https://github.com/948080952/YuXin\n如有bug或意见请点击下方反馈按钮或直接与代培联系，qq:948080952" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)feedback {
    [self sendContactMessageWithSubject:@"喻信意见反馈"];
}

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
