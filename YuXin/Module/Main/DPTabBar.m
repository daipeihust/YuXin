//
//  DPTabBar.m
//  YuXin
//
//  Created by Dai Pei on 16/7/24.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPTabBar.h"
#import "DPTabBarItem.h"

@interface DPTabBar()

@property (nonatomic, strong) NSArray<DPTabBarItem *> *tabBarItmes;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIView *separationLine;

@end

@implementation DPTabBar

- (instancetype)initWithTabBarItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.tabBarItmes = items;
        _selectedIndex = 0;
        [self configParent];
        [self configCell];
    }
    return self;
}

- (void)configParent {
    self.bounds = CGRectMake(0, 0, screenWidth, 44);
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.separationLine];
    [self.separationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)configCell {
    
    self.itemWidth = screenWidth / self.tabBarItmes.count;
    
    DPTabBarItem *item0 = self.tabBarItmes[0];
    [item0 setSelected:YES];
    
    for (int i = 0; i < self.tabBarItmes.count; i++) {
        DPTabBarItem *item = self.tabBarItmes[i];
        item.frame = CGRectMake(i * self.itemWidth, 0, self.itemWidth, 44);
        item.tag = i;
        [item addTarget:self action:@selector(itemDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}

- (void)itemDidSelected:(DPTabBarItem *)sender {
    [self setSelectedIndex:sender.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemDidSelectAtIndex:)]) {
        [self.delegate itemDidSelectAtIndex:sender.tag];
    }
}

#pragma mark - Setter

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    DPTabBarItem *item = self.tabBarItmes[_selectedIndex];
    [item setSelected:NO];
    item.userInteractionEnabled = YES;
    item = self.tabBarItmes[selectedIndex];
    [item setSelected:YES];
    item.userInteractionEnabled = NO;
    _selectedIndex = selectedIndex;
}

- (UIView *)separationLine {
    if (!_separationLine) {
        _separationLine = [[UIView alloc] init];
        _separationLine.backgroundColor = DPTabBarTopLineColor;
    }
    return _separationLine;
}

@end
