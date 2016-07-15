//
//  UserHelper.h
//  YuXin
//
//  Created by Dai Pei on 16/7/14.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginHandler)(NSString *message);

@interface UserHelper : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

+ (instancetype)sharedInstance;
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(LoginHandler)handler;

@end
