//
//  UserHelper.h
//  YuXin
//
//  Created by Dai Pei on 16/7/14.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MessageHandler)(NSString *message);
typedef void(^FavouriteHandler)(NSString *error, NSArray *models);

@interface UserHelper : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *favourateBoard;
@property (nonatomic, strong) YuXinUserInfo *userInfo;
@property (nonatomic, strong) NSArray <YuXinFriend *> *friendList;
@property (nonatomic, strong) NSNumber *openCount;
@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, assign) BOOL showColorfulText;
@property (nonatomic, assign) BOOL flexibleHome;
@property (nonatomic, assign) BOOL firstOpen;
@property (nonatomic, assign) BOOL loginState;

+ (instancetype)sharedInstance;
- (void)start;
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(MessageHandler)handler;
- (void)getFavourateBoardWithCompletion:(FavouriteHandler)handler;
- (void)refreshFavourateBoardWithCompletion:(FavouriteHandler)handler;
- (void)logoutWithCompletion:(MessageHandler)handler;

@end
