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
@property (nonatomic, assign) NSUInteger index;

- (void)fillDataWithModel:(YuXinArticle *)model;

@end

@protocol DPArticleDetailCellDelegate <NSObject>

@optional
- (void)userImageViewDidClick:(NSString *)userID;
- (void)reprintButtonDidClick:(NSString *)fileName;
- (void)commentButtonDidClick;
- (void)replyButtonDidClick:(NSUInteger)index;
- (void)deleteButtonDidClick:(NSString *)fileName;

@end