//
//  DPUserInfoViewController.m
//  YuXin
//
//  Created by Dai Pei on 2016/8/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPUserInfoViewController.h"
#import "YuXinModel.h"
#import "DPUserInfoCell.h"
#import "WSProgressHUD.h"
#import "YuXinSDK.h"

typedef NS_ENUM(NSInteger, DPUserInfoCellContent) {
    DPUserInfoCellContentAvatar = 0,
    DPUserInfoCellContentUserID,
    DPUserInfoCellContentNickName,
    DPUserInfoCellContentGender,
    DPUserInfoCellContentHoroscope,
    DPUserInfoCellContentPostNum,
    DPUserInfoCellContentLoginCount,
    DPUserInfoCellContentLastLogin,
    DPUserInfoCellContentExp,
    DPUserInfoCellContentDuty,
    DPUserInfoCellContentLife,
    DPUserInfoCellContentNetAge
};

@interface DPUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) YuXinUserInfo *userInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) WSProgressHUD *hud;

@end

@implementation DPUserInfoViewController

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        self.title = @"用户信息";
        self.userID = userID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ConfigView

- (void)initView {
    self.view.backgroundColor = DPBackgroundColor;
    self.tableView.backgroundColor = DPBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.hud];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }else {
        return 44;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPUserInfoCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:DPUserInfoImageCellReuseIdentifier];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:DPUserInfoNormalCellReuseIdentifier];
    }
    NSDictionary *dic;
    switch (indexPath.row) {
        case DPUserInfoCellContentAvatar: {
            dic = @{@"头像":@""};
            break;
        }
        case DPUserInfoCellContentUserID: {
            NSString *userId = self.userInfo.userID;
            dic = @{@"用户名":userId? userId : @""};
            break;
        }
        case DPUserInfoCellContentNickName: {
            NSString *nickName = self.userInfo.nickName;
            dic = @{@"昵称":nickName? nickName : @""};
            break;
        }
        case DPUserInfoCellContentGender: {
            NSString *gender = self.userInfo.gender;
            if ([gender isEqualToString:@"M"]) {
                gender = @"汉子";
            }
            else if ([gender isEqualToString:@"F"]) {
                gender = @"妹子";
            }
            else {
                gender = @"保密";
            }
            dic = @{@"性别":gender};
            break;
        }
        case DPUserInfoCellContentHoroscope: {
            NSString *horoscope = self.userInfo.horoscope;
            dic = @{@"星座":horoscope? horoscope : @""};
            break;
        }
        case DPUserInfoCellContentPostNum: {
            NSString *postNum = self.userInfo.postNum;
            dic = @{@"发帖数":postNum? postNum : @""};
            break;
        }
        case DPUserInfoCellContentLoginCount: {
            NSString *loginCount = self.userInfo.loginNum;
            dic = @{@"上站次数":loginCount? loginCount : @""};
            break;
        }
        case DPUserInfoCellContentLastLogin: {
            NSString *lastLogin = self.userInfo.readableLastLogin;
            dic = @{@"上次登录":lastLogin? lastLogin : @""};
            break;
        }
        case DPUserInfoCellContentExp: {
            NSString *exp = self.userInfo.experienceValue;
            dic = @{@"经验":exp? exp : @""};
            break;
        }
        case DPUserInfoCellContentDuty: {
            NSString *duty = self.userInfo.duty;
            dic = @{@"级别":duty? duty : @""};
            break;
        }
        case DPUserInfoCellContentLife: {
            NSString *life = self.userInfo.life;
            dic = @{@"生命力":life? life : @""};
            break;
        }
        case DPUserInfoCellContentNetAge: {
            NSString *netAge = self.userInfo.netAge;
            dic = @{@"网龄":netAge? netAge : @""};
            break;
        }
        default:
            break;
    }
    [cell fillDataWith:dic];
    return cell;
}

#pragma mark - Privite Method

- (void)initData {
    [self.hud show];
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] queryUserInfoWithUserID:self.userID completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            self.userInfo = [responseModels firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView setHidden:NO];
                [weakSelf.hud dismiss];
                [weakSelf.tableView reloadData];
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
        [_tableView registerClass:[DPUserInfoCell class] forCellReuseIdentifier:DPUserInfoNormalCellReuseIdentifier];
        [_tableView registerClass:[DPUserInfoCell class] forCellReuseIdentifier:DPUserInfoImageCellReuseIdentifier];
        _tableView.hidden = YES;
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
