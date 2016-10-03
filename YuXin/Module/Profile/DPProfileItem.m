//
//  DPProfileItem.m
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPProfileItem.h"
#import "UserHelper.h"

@implementation DPProfileItem

+ (DPProfileItem *)itemWithType:(DPProfileItemType)type {
    switch (type) {
        case DPProfileItemTypeUserInfo:
            return [self userInfoItem];
            break;
        case DPProfileItemTypeFriend:
            return [self friendItem];
            break;
        case DPProfileItemTypeAutoLogin:
            return [self autoLoginItem];
            break;
        case DPProfileItemTypeColorfulText:
            return [self colorfulTextItem];
            break;
        case DPProfileItemTypeFlexibleHome:
            return [self flexibleHomeItem];
            break;
        case DPProfileItemTypeShowSignature:
            return [self showSignature];
            break;
        case DPProfileItemTypeAboutUs:
            return [self aboutUsItem];
            break;
        case DPProfileItemTypeFeedback:
            return [self feedbackItem];
            break;
        case DPProfileItemTypeLogout:
            return [self logoutItem];
            break;
        default:
            break;
    }
    return nil;
}

+ (DPProfileItem *)userInfoItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = [UserHelper sharedInstance].userName;
    item.title2 = [UserHelper sharedInstance].userInfo.experienceDescription;
    return item;
}

+ (DPProfileItem *)friendItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"好友";
    item.title2 = [NSString stringWithFormat:@"%lu", (unsigned long)[UserHelper sharedInstance].friendList.count];
    return item;
}

+ (DPProfileItem *)autoLoginItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"自动登录";
    item.title2 = [UserHelper sharedInstance].autoLogin? @"On" : @"Off";
    return item;
}

+ (DPProfileItem *)colorfulTextItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"彩色帖文";
    item.title2 = [UserHelper sharedInstance].showColorfulText? @"On" : @"Off";
    return item;
}

+ (DPProfileItem *)flexibleHomeItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"灵动主页";
    item.title2 = [UserHelper sharedInstance].flexibleHome? @"On" : @"Off";
    return item;
}

+ (DPProfileItem *)showSignature {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"发帖签名";
    item.title2 = [UserHelper sharedInstance].showSignature? @"On" : @"Off";
    return item;
}

+ (DPProfileItem *)aboutUsItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"关于";
    return item;
}

+ (DPProfileItem *)feedbackItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"反馈";
    return item;
}

+ (DPProfileItem *)logoutItem {
    DPProfileItem *item = [[DPProfileItem alloc] init];
    item.title1 = @"Logout";
    return item;
}

@end
