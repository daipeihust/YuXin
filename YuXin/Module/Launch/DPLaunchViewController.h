//
//  DPLaunchViewController.h
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationHandler)();

@interface DPLaunchViewController : UIViewController

- (void)playAnimationToLoginVCWithCompletion:(AnimationHandler)handler;

@end
