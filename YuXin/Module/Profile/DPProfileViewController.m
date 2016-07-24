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

@interface DPProfileViewController () <UITableViewDelegate, UITableViewDataSource, DPProfileCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DPProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConfigView

- (void)initView {
    self.title = @"Me";
    [self.view setBackgroundColor:DPBackgroundColor];
    [self.tableView setBackgroundColor:DPBackgroundColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - DPProfileCellDelegate

- (void)switchChangeTo:(BOOL)state atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[UserHelper sharedInstance] setAutoLogin:state];
    }
    else {
        [[UserHelper sharedInstance] setShowColorfulText:state];
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
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return NO;
    }else {
        return YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DPProfileTableViewHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    
    return sectionHeaderView;
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
                item.title2 = [UserHelper sharedInstance].autoLogin? @"On" : @"Off";
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
    [cell fillDataWith:item];
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

#pragma mark - override
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"offset:%f", scrollView.contentOffset.y);
//    CGFloat sectionHeaderHeight = DPProfileTableViewHeaderHeight;
//    CGFloat navigationOffSet = -64;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight + navigationOffSet && scrollView.contentOffset.y>=navigationOffSet) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DPProfileCell class] forCellReuseIdentifier:DPProfileUserCellReuseIdentifier];
        [_tableView registerClass:[DPProfileCell class] forCellReuseIdentifier:DPProfileNormalCellReuseIdentifier];
        [_tableView registerClass:[DPProfileCell class] forCellReuseIdentifier:DPProfileSwitchCellReuseIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}


@end
