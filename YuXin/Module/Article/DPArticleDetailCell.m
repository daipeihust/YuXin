//
//  DPArticleDetailCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleDetailCell.h"
#import "UserHelper.h"

typedef NS_ENUM(NSUInteger, DPArticleDetailCellType) {
    DPArticleDetailCellTypeArticle,
    DPArticleDetailCellTypeComment
};

@interface DPArticleDetailCell()

@property (nonatomic, assign) DPArticleDetailCellType cellType;
@property (nonatomic, strong) YuXinArticle *model;

//common
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *timeLabel;


//article part
@property (nonatomic, strong) UILabel *articleTitle;
@property (nonatomic, strong) UILabel *articleContent;
@property (nonatomic, strong) UILabel *authorName;
@property (nonatomic, strong) UIImageView *commentBtn;
@property (nonatomic, strong) UIImageView *reprintBtn;
@property (nonatomic, strong) UIImageView *deleteBtn1;

//comment part
@property (nonatomic, strong) UILabel *commentTitle;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UILabel *commentContent;
@property (nonatomic, strong) UIButton *deleteBtn2;

@end

@implementation DPArticleDetailCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier  isEqual:DPArticleDetailCellReuseIdentifier]) {
            self.cellType = DPArticleDetailCellTypeArticle;
        }
        else if ([reuseIdentifier isEqualToString:DPArticleCommentCellReuseIdentifier]) {
            self.cellType = DPArticleDetailCellTypeComment;
        }
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self layoutViews];
    }
    return self;
}

#pragma mark - Privite Method

- (void)fillDataWithModel:(YuXinArticle *)model {
    self.model = model;
    if (self.cellType == DPArticleDetailCellTypeArticle) {
        self.articleTitle.text = model.title;
        self.authorName.text = model.author;
        if (model.userIDAndName) {
            self.authorName.text = model.userIDAndName;
        }
        self.articleContent.text = model.realContent;
        if (model.displayContent) {
            self.articleContent.text = model.displayContent;
        }
        if (model.colorfulContent) {
            self.articleContent.text = nil;
            self.articleContent.attributedText = model.colorfulContent;
        }
        self.timeLabel.text = model.readableDate;
        if ([model.author isEqualToString:[UserHelper sharedInstance].userName]) {
            self.deleteBtn1.hidden = NO;
        }else {
            self.deleteBtn1.hidden = YES;
        }
    }
    else if (self.cellType == DPArticleDetailCellTypeComment) {
        self.commentTitle.text = model.author;
        if (model.userIDAndName) {
            self.commentTitle.text = model.userIDAndName;
        }
        self.commentContent.text = model.realContent;
        if (model.displayContent) {
            self.commentContent.text = model.displayContent;
        }
        if (model.colorfulContent) {
            self.commentContent.text = nil;
            self.commentContent.attributedText = model.colorfulContent;
        }
        self.timeLabel.text = model.readableDate;
        if ([model.author isEqualToString:[UserHelper sharedInstance].userName]) {
            self.deleteBtn2.hidden = NO;
            self.replyBtn.hidden = YES;
        }else {
            self.deleteBtn2.hidden = YES;
            self.replyBtn.hidden = NO;
        }
    }
}

#pragma mark - ConfigUI

- (void)layoutViews {
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.timeLabel];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(10);
        make.height.width.mas_equalTo(40);
    }];
    
    if (self.cellType == DPArticleDetailCellTypeArticle) {
        [self.contentView addSubview:self.articleTitle];
        [self.contentView addSubview:self.articleContent];
        [self.contentView addSubview:self.authorName];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.reprintBtn];
        [self.contentView addSubview:self.deleteBtn1];
        
        [self.articleTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.articleTitle);
            make.top.equalTo(self.articleTitle.mas_bottom).with.offset(5);
            make.right.equalTo(self.articleTitle);
        }];
        [self.articleContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.authorName.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        [self.reprintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.articleContent.mas_bottom).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.height.mas_equalTo(25);
        }];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.articleContent.mas_bottom).with.offset(10);
            make.right.equalTo(self.reprintBtn.mas_left).with.offset(-20);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.height.mas_equalTo(25);
        }];
        [self.deleteBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.articleContent.mas_bottom).with.offset(10);
            make.right.equalTo(self.commentBtn.mas_left).with.offset(-20);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.height.mas_equalTo(25);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.articleContent.mas_bottom).with.offset(10);
            make.width.mas_equalTo(100);
        }];
    }
    else if (self.cellType == DPArticleDetailCellTypeComment) {
        [self.contentView addSubview:self.commentTitle];
        [self.contentView addSubview:self.commentContent];
        [self.contentView addSubview:self.deleteBtn2];
        [self.contentView addSubview:self.replyBtn];
        
        [self.deleteBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(self.contentView).with.offset(10);
            make.width.mas_equalTo(50);
        }];
        [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.deleteBtn2);
        }];
        [self.commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            make.right.equalTo(self.deleteBtn2.mas_left);
            make.height.mas_equalTo(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentTitle.mas_bottom).with.offset(5);
            make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            make.width.mas_equalTo(100);
        }];
        [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userImageView.mas_bottom).with.offset(20);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
    }
}

#pragma mark - Privite Method



#pragma mark - Action Method

- (void)userImageViewClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userImageViewDidClick:)]) {
        [self.delegate userImageViewDidClick:self.model.author];
    }
}

- (void)deleteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonDidClick:)]) {
        [self.delegate deleteButtonDidClick:self.model.fileName];
    }
}

- (void)commentButtonClicked {
    
}

#pragma mark - Getter

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.backgroundColor = [UIColor grayColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 20;
    }
    return _userImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = DPSecondLevelTitleColor;
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)articleTitle {
    if (!_articleTitle) {
        _articleTitle = [[UILabel alloc] init];
        _articleTitle.textColor = DPFirstLevelTitleColor;
        _articleTitle.numberOfLines = 0;
        _articleTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _articleTitle.textAlignment = NSTextAlignmentLeft;
        _articleTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _articleTitle;
}

- (UILabel *)authorName {
    if (!_authorName) {
        _authorName = [[UILabel alloc] init];
        _authorName.textColor = DPSecondLevelTitleColor;
        _authorName.numberOfLines = 1;
        _authorName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _authorName.textAlignment = NSTextAlignmentLeft;
    }
    return _authorName;
}

- (UIImageView *)reprintBtn {
    if (!_reprintBtn) {
        _reprintBtn = [[UIImageView alloc] init];
        _reprintBtn.backgroundColor = [UIColor yellowColor];
        
    }
    return _reprintBtn;
}

- (UIImageView *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIImageView alloc] init];
        _commentBtn.backgroundColor = [UIColor blueColor];
        
    }
    return _commentBtn;
}

- (UIImageView *)deleteBtn1 {
    if (!_deleteBtn1) {
        _deleteBtn1 = [[UIImageView alloc] init];
        _deleteBtn1.backgroundColor = [UIColor redColor];
    }
    return _deleteBtn1;
}

- (UILabel *)articleContent {
    if (!_articleContent) {
        _articleContent = [[UILabel alloc] init];
        _articleContent.textColor = DPBodyTextColor;
        _articleContent.numberOfLines = 0;
        _articleContent.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _articleContent.textAlignment = NSTextAlignmentLeft;
        _articleContent.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _articleContent;
}

- (UILabel *)commentTitle {
    if (!_commentTitle) {
        _commentTitle = [[UILabel alloc] init];
        _commentTitle.textColor = DPFirstLevelTitleColor;
        _commentTitle.numberOfLines = 1;
        _commentTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _commentTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _commentTitle;
}

- (UILabel *)commentContent {
    if (!_commentContent) {
        _commentContent = [[UILabel alloc] init];
        _commentContent.textColor = DPBodyTextColor;
        _commentContent.numberOfLines = 0;
        _commentContent.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _commentContent.textAlignment = NSTextAlignmentLeft;
        _commentContent.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _commentContent;
}

- (UIButton *)deleteBtn2 {
    if (!_deleteBtn2) {
        _deleteBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_deleteBtn2 setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _deleteBtn2;
}

- (UIButton *)replyBtn {
    if (!_replyBtn) {
        _replyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _replyBtn;
}

@end
