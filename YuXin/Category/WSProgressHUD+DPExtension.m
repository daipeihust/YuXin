//
//  WSProgressHUD+DPExtension.m
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "WSProgressHUD+DPExtension.h"

static NSMutableArray<NSString *> *taskArray;
static BOOL displaying;

@implementation WSProgressHUD (DPExtension)


+ (void)autoDismiss {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (taskArray.count) {
            [self showImage:nil status:taskArray[0]];
            [taskArray removeObjectAtIndex:0];
            [self autoDismiss];
        }else {
            displaying = NO;
            [self dismiss];
        }
    });
}

+ (void)safeShowString:(NSString *)string {
    if (!taskArray) {
        taskArray = [NSMutableArray array];
    }
    if (!taskArray.count && !displaying) {
        displaying = YES;
        [self showImage:nil status:string];
        [self autoDismiss];
    }else {
        [taskArray addObject:string];
    }
}



@end
