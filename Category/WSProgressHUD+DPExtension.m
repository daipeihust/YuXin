//
//  WSProgressHUD+DPExtension.m
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "WSProgressHUD+DPExtension.h"

@implementation WSProgressHUD (DPExtension)

+ (void)autoDismiss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

@end
