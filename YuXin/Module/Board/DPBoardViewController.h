//
//  DPBoardViewController.h
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPBoardType) {
    DPBoardTypeYuXinXingKong,
    DPBoardTypeDianXinFengCai,
    DPBoardTypeShuZiShiDai,
    DPBoardTypeXueShuXueKe,
    DPBoardTypeRenWenYiShu,
    DPBoardTypeChunZhenShiDai,
    DPBoardTypeXiuXianYuLe,
    DPBoardTypeShiShiKuaiDi,
    DPBoardTypeFavourate
};

@interface DPBoardViewController : UIViewController

- (instancetype)initWithBoardType:(DPBoardType)boardType;

@end
