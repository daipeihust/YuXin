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

+ (instancetype)sharedInstance {
    static UserHelper *instance = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        instance = [[UserHelper alloc] init];
        instance.favourateBoard = [NSArray array];
    });
    return instance;
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(LoginHandler)handler {
    self.userName = userName;
    self.password = password;
    [[YuXinSDK sharedInstance] loginWithUsername:userName password:password completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            handler(@"Login Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:DPNotificationLoginSuccess object:nil];
        }else {
            handler(error);
        }
    }];
}

- (void)getFavourateBoardCompletion:(FavouriteHandler)handler {
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



@end
