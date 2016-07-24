//
//  DPTabBarItem.m
//  YuXin
//
//  Created by Dai Pei on 16/7/24.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPTabBarItem.h"

@implementation DPTabBarItem

- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    self = [super init];
    if (self) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        self.adjustsImageWhenDisabled = NO;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

@end
