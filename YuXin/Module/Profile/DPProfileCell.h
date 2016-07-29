//
//  DPProfileCell.h
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPProfileItem;

@protocol DPProfileCellDelegate;

@interface DPProfileCell : UITableViewCell

@property (nonatomic, weak) id<DPProfileCellDelegate> delegate;

- (void)fillDataWith:(DPProfileItem *)item indexPath:(NSIndexPath *)indexPath;

@end


@protocol DPProfileCellDelegate <NSObject>

- (void)switchChangeTo:(BOOL)state atIndexPath:(NSIndexPath *)indexPath;

@end