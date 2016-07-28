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
@synthesize openCount = _openCount;

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
        self.autoLogin = YES;
        self.showColorfulText = YES;
    }else {
        if (self.autoLogin) {
            [self tryAutoLogin];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowLoginVC object:nil];
        }
    }
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(MessageHandler)handler {
    self.userName = userName;
    self.password = password;
    [[YuXinSDK sharedInstance] loginWithUsername:userName password:password completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            handler(@"Login Success");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationLoginSuccess object:nil];
            });
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DPUsernameKey];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:DPPasswordKey];
        }else {
            handler(error);
        }
    }];
}

- (void)logoutWithCompletion:(MessageHandler)handler {
    [[YuXinSDK sharedInstance] logoutWithCompletion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            handler(@"Logout Success");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationLogoutSuccess object:nil];
            });
        }else {
            handler(error);
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

- (void)refreshFavourateBoard {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchFavourateBoardWithCompletion:^(NSString *error, NSArray *responseModels) {
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

#pragma mark - Privite Method

- (void)tryAutoLogin {
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:DPUsernameKey];
    self.password = [[NSUserDefaults standardUserDefaults] objectForKey:DPPasswordKey];
    if (self.userName && self.password) {
        [[YuXinSDK sharedInstance] loginWithUsername:self.userName password:self.password completion:^(NSString *error, NSArray *responseModels) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationShowMainVC object:nil];
                });
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

#pragma mark - Setter

- (void)setAutoLogin:(BOOL)autoLogin {
    [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:DPAutoLoginKey];
    _autoLogin = autoLogin;
}

- (void)setShowColorfulText:(BOOL)showColorfulText {
    [[NSUserDefaults standardUserDefaults] setBool:showColorfulText forKey:DPShowColorfulTextKey];
    _showColorfulText = showColorfulText;
}

- (void)setOpenCount:(NSNumber *)openCount {
    [[NSUserDefaults standardUserDefaults] setObject:openCount forKey:DPOpenCountKey];
    _openCount = openCount;
}

#pragma mark - Getter

-(BOOL)showColorfulText{
    return [[NSUserDefaults standardUserDefaults] boolForKey:DPShowColorfulTextKey];
}

- (BOOL)autoLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DPAutoLoginKey];
}

- (NSNumber *)openCount {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DPOpenCountKey];
}

@end
