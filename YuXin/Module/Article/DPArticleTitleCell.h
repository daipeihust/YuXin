//
//  DPArticleTitleCell.h
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPArticleTitleCell : UITableViewCell

@property (nonatomic, assign)CGFloat cellHeight;

- (void)fillDataWithModel:(YuXinTitle *)model;

@end
