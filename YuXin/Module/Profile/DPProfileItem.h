//
//  DPProfileItem.h
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DPProfileItemType) {
    DPProfileItemTypeUserInfo,
    DPProfileItemTypeFriend,
    DPProfileItemTypeAutoLogin,
    DPProfileItemTypeColorfulText,
    DPProfileItemTypeFlexibleHome,
    DPProfileItemTypeAboutUs,
    DPProfileItemTypeFeedback,
    DPProfileItemTypeLogout,
    DPProfileItemNumber
};

@interface DPProfileItem : NSObject

@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSString *title1;
@property (nonatomic, strong) NSString *title2;
@property (nonatomic, assign) NSIndexPath *indexPath;

+ (DPProfileItem *)itemWithType:(DPProfileItemType)type;

@end
