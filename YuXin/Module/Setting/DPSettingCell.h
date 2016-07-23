//
//  DPSettingCell.h
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPSettingItem;

@interface DPSettingCell : UITableViewCell

- (void)fillDataWith:(DPSettingItem *)item;

@end
