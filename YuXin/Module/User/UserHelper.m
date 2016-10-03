//
//  UserHelper.m
//  YuXin
//
//  Created by Dai Pei on 16/7/14.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "UserHelper.h"
#import "YuXinSDK.h"

@implementation UserHelper
@synthesize autoLogin = _autoLogin;
@synthesize showColorfulText = _showColorfulText;
@synthesize flexibleHome = _flexibleHome;
@synthesize openCount = _openCount;
@synthesize loginState = _loginState;
@synthesize password = _password;
@synthesize userName = _userName;

+ (instancetype)sharedInstance {
    static UserHelper *instance = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        instance = [[UserHelper alloc] init];
        instance.favourateBoard = [NSArray array];
    });
    return instance;
}

#pragma mark - Public Method

- (void)start {
    if (!self.openCount) {
        self.openCount = @(1);
        self.firstOpen = YES;
    }else {
        self.openCount = @(self.openCount.integerValue + 1);
        self.firstOpen = NO;
    }
    if (self.firstOpen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowLoginVC object:nil];
        self.loginState = YES;
        self.autoLogin = YES;
        self.showColorfulText = YES;
        self.flexibleHome = YES;
    }else {
        if (self.autoLogin && self.loginState) {
            [self tryAutoLogin];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowLoginVC object:nil];
        }
    }
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(MessageHandler)handler {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] loginWithUsername:userName password:password completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.loginState = YES;
            if (handler) {
                handler(@"Login Success");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationLoginSuccess object:nil];
            });
            weakSelf.userName = userName;
            weakSelf.password = password;
            [weakSelf initFriendList];
            [weakSelf initUserInfo];
            [weakSelf refreshFavourateBoardWithCompletion:nil];
        }else {
            if (handler) {
                handler(error);
            }
        }
    }];
}

- (void)logoutWithCompletion:(MessageHandler)handler {
    [[YuXinSDK sharedInstance] logoutWithCompletion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            self.loginState = NO;
            if (handler) {
                handler(@"Logout Success");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationLogoutSuccess object:nil];
            });
        }else {
            if (handler) {
                handler(error);
            }
        }
    }];
}

- (void)getFavourateBoardWithCompletion:(FavouriteHandler)handler {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchFavourateBoardWithCompletion:^(NSString *error, NSArray *responseModels) {
        handler(error, responseModels);
        if (!error) {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i = 0; i < responseModels.count; i++) {
                YuXinBoard *board = responseModels[i];
                [tmpArray addObject:board.boardName];
            }
            weakSelf.favourateBoard = [tmpArray copy];
        }
    }];
}

- (void)refreshFavourateBoardWithCompletion:(FavouriteHandler)handler {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchFavourateBoardWithCompletion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i = 0; i < responseModels.count; i++) {
                YuXinBoard *board = responseModels[i];
                [tmpArray addObject:board.boardName];
            }
            weakSelf.favourateBoard = [tmpArray copy];
            if (handler) {
                handler(nil, tmpArray);
            }
        }
    }];
}

#pragma mark - Privite Method

- (void)tryAutoLogin {
    __weak typeof(self) weakSelf = self;
    if (self.userName && self.password) {
        [[YuXinSDK sharedInstance] loginWithUsername:self.userName password:self.password completion:^(NSString *error, NSArray *responseModels) {
            if (!error) {
                weakSelf.loginState = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowMainVC object:nil];
                });
                [weakSelf initFriendList];
                [weakSelf initUserInfo];
                [weakSelf refreshFavourateBoardWithCompletion:nil];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowLoginVC object:nil];
                });
            }
        }];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowLoginVC object:nil];
    }
}

- (void)initFriendList {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchFriendListWithCompletion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.friendList = [NSArray arrayWithArray:responseModels];
        }
    }];
}

- (void)initUserInfo {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] queryUserInfoWithUserID:self.userName completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.userInfo = [responseModels firstObject];
        }
    }];
}

#pragma mark - Setter

- (void)setAutoLogin:(BOOL)autoLogin {
    [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:DPAutoLoginKey];
    _autoLogin = autoLogin;
}

- (void)setShowColorfulText:(BOOL)showColorfulText {
    [[NSUserDefaults standardUserDefaults] setBool:showColorfulText forKey:DPShowColorfulTextKey];
    _showColorfulText = showColorfulText;
}

- (void)setFlexibleHome:(BOOL)flexibleHome {
    [[NSUserDefaults standardUserDefaults] setBool:flexibleHome forKey:DPFlexibleHomeKey];
    _flexibleHome = flexibleHome;
}

- (void)setOpenCount:(NSNumber *)openCount {
    [[NSUserDefaults standardUserDefaults] setObject:openCount forKey:DPOpenCountKey];
    _openCount = openCount;
}

- (void)setLoginState:(BOOL)loginState {
    [[NSUserDefaults standardUserDefaults] setBool:loginState forKey:DPLoginStateKey];
    _loginState = loginState;
}

- (void)setUserName:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DPUsernameKey];
    _userName = userName;
}

- (void)setPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:DPPasswordKey];
    _password = password;
}

#pragma mark - Getter

-(BOOL)showColorfulText{
    return [[NSUserDefaults standardUserDefaults] boolForKey:DPShowColorfulTextKey];
}

- (BOOL)autoLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DPAutoLoginKey];
}

- (BOOL)flexibleHome {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DPFlexibleHomeKey];
}

- (BOOL)loginState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DPLoginStateKey];
}

- (NSNumber *)openCount {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DPOpenCountKey];
}

- (NSString *)userName {
    if (!_userName) {
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:DPUsernameKey];
    }
    return _userName;
}

- (NSString *)password {
    if (!_password) {
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:DPPasswordKey];
    }
    return _password;
}

@end
