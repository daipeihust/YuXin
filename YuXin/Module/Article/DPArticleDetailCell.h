//
//  DPArticleDetailCell.h
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YuXinArticle;

typedef NS_ENUM(NSUInteger, DPArticleDetailCellType) {
    DPArticleDetailCellTypeArticle,
    DPArticleDetailCellTypeComment
};

@protocol DPArticleDetailCellDelegate;

@interface DPArticleDetailCell : UITableViewCell

@property (nonatomic, assign) DPArticleDetailCellType cellType;
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
