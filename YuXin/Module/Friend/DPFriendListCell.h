//
//  DPFriendListCell.h
//  YuXin
//
//  Created by Dai Pei on 2016/8/7.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YuXinFriend;

@interface DPFriendListCell : UITableViewCell

- (void)fillDataWithModel:(YuXinFriend *)model;

@end
