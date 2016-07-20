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

@end
