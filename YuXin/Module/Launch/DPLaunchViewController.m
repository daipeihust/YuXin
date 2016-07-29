//
//  DPLaunchViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPLaunchViewController.h"

@interface DPLaunchViewController()

@property (nonatomic, strong) UIView *launchView;

@end

@implementation DPLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    self.launchView = viewController.view.subviews[0];
    self.view.backgroundColor = DPLoginBackgroundColor;
    [self.view addSubview:self.launchView];
    [self.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)playAnimationToLoginVCWithCompletion:(AnimationHandler)handler {
    [UIView animateWithDuration:1.f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.launchView.transform = CGAffineTransformMakeTranslation(0, -50 * (1 + widthRateForFit) - 30);
    } completion:^(BOOL finished) {
        handler();
    }];
}

@end
