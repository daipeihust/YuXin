//
//  UIViewController+DPExtension.m
//  YuXin
//
//  Created by Dai Pei on 2016/10/3.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "UIViewController+DPExtension.h"

@implementation UIViewController (DPExtension)

+ (UIViewController *)topMostViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    BOOL isPresenting = NO;
    do {
        UIViewController *presented = rootViewController.presentedViewController;
        if (presented != nil) {
            isPresenting = YES;
            rootViewController = presented;
        }
    } while (isPresenting);
    
    return rootViewController;
}


@end
