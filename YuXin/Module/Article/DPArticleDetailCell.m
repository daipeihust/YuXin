//
//  DPArticleDetailCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleDetailCell.h"

typedef NS_ENUM(NSUInteger, DPArticleDetailCellType) {
    DPArticleDetailCellTypeArticle,
    DPArticleDetailCellTypeComment
};

@interface DPArticleDetailCell()

@property (nonatomic, assign) DPArticleDetailCellType cellType;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *articleTitle;
@property (nonatomic, strong) UILabel *authorName;


@end

@implementation DPArticleDetailCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier  isEqual:DPArticleDetailCellReuseIdentifier]) {
            self.cellType = DPArticleDetailCellTypeArticle;
        }else if ([reuseIdentifier isEqualToString:DPArticleCommentCellReuseIdentifier]) {
            self.cellType = DPArticleDetailCellTypeComment;
        }
        
    }
    return self;
}

#pragma mark - Privite Method

- (void)fillDataWithModel:(YuXinArticle *)model {
    
}

#pragma mark - ConfigUI

- (void)layoutViews {
    
}

@end
