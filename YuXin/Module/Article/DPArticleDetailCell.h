//
//  DPArticleDetailCell.h
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPArticleDetailCellDelegate;

@interface DPArticleDetailCell : UITableViewCell

@property (nonatomic, weak) id<DPArticleDetailCellDelegate> delegate;

- (void)fillDataWithModel:(YuXinArticle *)model;

@end

@protocol DPArticleDetailCellDelegate <NSObject>

@optional
- (void)userImageViewDidClick:(NSString *)userID;
- (void)reprintButtonDidClick;
- (void)commentButtonDidClick;
- (void)replyButtonDidClick;
- (void)deleteButtonDidClick:(NSString *)fileName;

@end