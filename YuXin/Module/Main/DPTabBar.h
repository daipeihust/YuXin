//
//  DPTabBar.h
//  YuXin
//
//  Created by Dai Pei on 16/7/24.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPTabBarItem;

@protocol DPTabBarDelegate;

@interface DPTabBar : UIView

@property (nonatomic, weak) id<DPTabBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithTabBarItems:(NSArray *)items;


@end


@protocol DPTabBarDelegate <NSObject>

- (void)itemDidSelectAtIndex:(NSUInteger)index;

@end