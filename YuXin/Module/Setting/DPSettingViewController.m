//
//  DPSettingViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPSettingViewController.h"
#import "DPSettingCell.h"
#import "DPSettingItem.h"

@interface DPSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPSettingCell *cell;
    DPSettingItem *item;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:DPSettingUserCellReuseIdentifier];
            
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:DPSettingNormalCellReuseIdentifier];
            
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:DPSettingSwitchCellReuseIdentifier];
            
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:DPSettingNormalCellReuseIdentifier];
            
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:DPSettingNormalCellReuseIdentifier];
            
            break;
        default:
            break;
    }
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
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[DPSettingCell class] forCellReuseIdentifier:DPSettingUserCellReuseIdentifier];
        [_tableView registerClass:[DPSettingCell class] forCellReuseIdentifier:DPSettingNormalCellReuseIdentifier];
        [_tableView registerClass:[DPSettingCell class] forCellReuseIdentifier:DPSettingSwitchCellReuseIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}


@end
