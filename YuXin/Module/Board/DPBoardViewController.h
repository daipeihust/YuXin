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

@protocol DPBoardViewControllerDelegate;

@interface DPBoardViewController : UIViewController

@property (nonatomic, weak) id<DPBoardViewControllerDelegate> delegate;

- (instancetype)initWithBoardType:(DPBoardType)boardType;

@end

@protocol DPBoardViewControllerDelegate <NSObject>

- (void)boardVCDidAppear;
- (void)boardVCWillDisappear;
- (void)boardVCDidDisappear;

@end
