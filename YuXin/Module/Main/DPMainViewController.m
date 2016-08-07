//
//  DPMainViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPMainViewController.h"
#import "DPAllPartViewController.h"
#import "DPBoardViewController.h"
#import "DPProfileViewController.h"
#import "DPTabBar.h"
#import "DPTabBarItem.h"

@interface DPMainViewController()<DPTabBarDelegate, DPProfileViewControllerDelegate, DPBoardViewControllerDelegate,DPAllPartViewControllerDelegate>

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, strong) DPTabBar *tabBar;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, assign) BOOL shouldChangeTabbarState;

@end

@implementation DPMainViewController

- (instancetype)initWithAnimationView:(UIView *)view {
    self = [super init];
    if (self) {
        self.animationView = view;
        self.shouldChangeTabbarState = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [self initTabBar];
    [self initViewController];
    [self initAnimationView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self playInitAnimation];
    
}

#pragma mark - ConfigView

- (void)initViewController {
    
    DPAllPartViewController *vc1 = [[DPAllPartViewController alloc] init];
    vc1.delegate = self;
    UINavigationController *nvc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    DPBoardViewController *vc2 = [[DPBoardViewController alloc] initWithBoardType:DPBoardTypeFavourate];
    vc2.delegate = self;
    UINavigationController *nvc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    DPProfileViewController *vc3 = [[DPProfileViewController alloc] init];
    vc3.delegate = self;
    UINavigationController *nvc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    [self addChildViewController:nvc1];
    [self addChildViewController:nvc2];
    [self addChildViewController:nvc3];
    self.viewControllers = @[nvc1, nvc2, nvc3];
    
    [nvc1 didMoveToParentViewController:self];
    [self.contentView addSubview:nvc1.view];
    [nvc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.selectedIndex = 0;
}

- (void)initTabBar {
    self.view.backgroundColor = DPBackgroundColor;
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBar];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-44);
    }];
    [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(self.tabBar.bounds.size.width);
        make.height.mas_equalTo(self.tabBar.bounds.size.height);
    }];
}

- (void)initAnimationView {
    [self.view addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - DPProfileViewControllerDelegate

- (void)profileVCDidAppear {
    [self showTarbar];
}

- (void)profileVCWillDisappear {
    [self hideTarbar];
}

- (void)profileVCDidDisappear {
    
}

#pragma mark - DPBoardViewControllerDelegate

- (void)boardVCDidAppear {
    [self showTarbar];
}

- (void)boardVCWillDisappear {
    [self hideTarbar];
}

- (void)boardVCDidDisappear {
    
}

#pragma mark - DPAllPartViewControllerDelegate

- (void)allPartVCDidAppear {
    [self showTarbar];
}

- (void)allPartVCWillDisappear {
    [self hideTarbar];
}

- (void)allPartVCDidDisappear {
    
}

#pragma mark - DPTabBarDelegate

- (void)itemDidSelectAtIndex:(NSUInteger)index {
    self.shouldChangeTabbarState = NO;
    [self didSelectIndex:index];
}

#pragma mark - Privite Method

- (void)didSelectIndex:(NSUInteger)index {
    if (self.selectedIndex == index) {
        return ;
    }
    UIViewController *fromVC = self.viewControllers[self.selectedIndex];
    UIViewController *toVC = self.viewControllers[index];
    [self transitionFromViewController:fromVC toViewController:toVC duration:0 options:UIViewAnimationOptionTransitionNone animations:^{} completion:^(BOOL finished) {
        self.selectedIndex = index;
        self.shouldChangeTabbarState = YES;
    }];
    [self.contentView addSubview:toVC.view];
    [toVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [fromVC.view removeFromSuperview];
}

- (void)playInitAnimation {
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.animationView.alpha = 0.0f;
        self.animationView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
    } completion:^(BOOL finished) {
        [self.animationView removeFromSuperview];
    }];
}

- (void)showTarbar {
    if (self.shouldChangeTabbarState) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(-44);
        }];
        [self.tabBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.mas_equalTo(self.tabBar.bounds.size.width);
            make.height.mas_equalTo(self.tabBar.bounds.size.height);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)hideTarbar {
    if (self.shouldChangeTabbarState) {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.tabBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view);
            make.width.mas_equalTo(self.tabBar.bounds.size.width);
            make.height.mas_equalTo(self.tabBar.bounds.size.height);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - Getter

- (DPTabBar *)tabBar {
    if (!_tabBar) {
        DPTabBarItem *item1 = [[DPTabBarItem alloc] initWithImage:[UIImage imageNamed:@"image_tabbar_home"] selectedImage:[UIImage imageNamed:@"image_tabbar_home_highlighted"]];
        DPTabBarItem *item2 = [[DPTabBarItem alloc] initWithImage:[UIImage imageNamed:@"image_tabbar_like"] selectedImage:[UIImage imageNamed:@"image_tabbar_like_highlighted"]];
        DPTabBarItem *item3 = [[DPTabBarItem alloc] initWithImage:[UIImage imageNamed:@"image_tabbar_profile"] selectedImage:[UIImage imageNamed:@"image_tabbar_profile_highlighted"]];
        _tabBar = [[DPTabBar alloc] initWithTabBarItems:@[item1, item2, item3]];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

@end
