//
//  WSProgressHUD+DPExtension.h
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <WSProgressHUD/WSProgressHUD.h>

@interface WSProgressHUD (DPExtension)

+ (void)autoDismiss;

+ (void)safeShowString:(NSString *)string;

@end
