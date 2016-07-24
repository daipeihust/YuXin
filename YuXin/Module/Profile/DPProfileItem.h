//
//  DPProfileItem.h
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPProfileItem : NSObject

@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSString *title1;
@property (nonatomic, strong) NSString *title2;
@property (nonatomic, assign) NSIndexPath *indexPath;

@end
