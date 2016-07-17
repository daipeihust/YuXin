//
//  DPArticleTitleCell.h
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPArticleTitleCellDelegate;

@interface DPArticleTitleCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, weak) id<DPArticleTitleCellDelegate> delegate;

- (void)fillDataWithModel:(YuXinTitle *)model;

@end

@protocol DPArticleTitleCellDelegate <NSObject>

@optional

- (void)userImageViewDidClick:(NSString *)userID;

@end