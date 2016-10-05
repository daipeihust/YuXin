//
//  DPArticleDetailCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleDetailCell.h"
#import "UserHelper.h"
#import "YuXinSDK.h"

@interface DPArticleDetailCell()

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
@property (nonatomic, strong) UIButton *deleteBtn1;
@property (nonatomic, strong) UIView *reprintTapArea;

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
        if (model.colorfulContent && [[UserHelper sharedInstance] showColorfulText]) {
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
        NSString *commentTitleStr;
        if (model.replyUserID) {
            commentTitleStr = [NSString stringWithFormat:@"%@回复%@", model.author, model.replyUserID];
        }else {
            commentTitleStr = model.author;
        }
        self.commentTitle.text = commentTitleStr;
        self.commentContent.text = model.realContent;
        if (model.displayContent) {
            self.commentContent.text = model.displayContent;
        }
        if (model.colorfulContent && [[UserHelper sharedInstance] showColorfulText]) {
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
        make.height.width.mas_equalTo(50);
    }];
    
    if (self.cellType == DPArticleDetailCellTypeArticle) {
        [self.contentView addSubview:self.articleTitle];
        [self.contentView addSubview:self.articleContent];
        [self.contentView addSubview:self.authorName];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.reprintBtn];
        [self.contentView addSubview:self.deleteBtn1];
        [self.contentView addSubview:self.reprintTapArea];
        
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
        [self.reprintTapArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.height.mas_equalTo(40);
        }];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.reprintBtn.mas_left).with.offset(-20);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.height.mas_equalTo(25);
        }];
        [self.deleteBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentBtn.mas_left).with.offset(-20);
            make.bottom.equalTo(self.contentView).with.offset(-10);
            make.width.height.mas_equalTo(25);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.centerY.equalTo(self.reprintBtn);
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
//            make.height.mas_equalTo(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentTitle.mas_bottom).with.offset(5);
            make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            make.width.mas_equalTo(100);
        }];
        [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userImageView.mas_bottom).with.offset(5);
            make.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
    }
}

#pragma mark - Action Method

- (void)userImageViewClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userImageViewDidClick:)]) {
        [self.delegate userImageViewDidClick:self.model.author];
    }
}

- (void)reprintButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reprintButtonDidClick:)]) {
        [self.delegate reprintButtonDidClick:self.model.fileName];
    }
}

- (void)deleteButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonDidClick:)]) {
        [self.delegate deleteButtonDidClick:self.model.fileName];
    }
}

- (void)commentButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentButtonDidClick)]) {
        [self.delegate commentButtonDidClick];
    }
}

- (void)replyButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyButtonDidClick:)]) {
        [self.delegate replyButtonDidClick:self.index];
    }
}

#pragma mark - Getter

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.backgroundColor = [UIColor grayColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 25;
        _userImageView.userInteractionEnabled = YES;
        _userImageView.image = [UIImage imageNamed:@"image_user_avatar"];
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.layer.borderWidth = 1.f;
        _userImageView.layer.borderColor = DPImageBorderColor.CGColor;
        [_userImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImageViewClicked)]];
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
        _reprintBtn.backgroundColor = [UIColor clearColor];
        _reprintBtn.image = [UIImage imageNamed:@"image_article_reprint"];
        _replyBtn.contentMode = UIViewContentModeCenter;
    }
    return _reprintBtn;
}

- (UIView *)reprintTapArea {
    if (!_reprintTapArea) {
        _reprintTapArea = [[UIView alloc] init];
        _reprintTapArea.backgroundColor = [UIColor clearColor];
        _reprintTapArea.userInteractionEnabled = YES;
        [_reprintTapArea addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reprintButtonClicked)]];
    }
    return _reprintTapArea;
}

- (UIImageView *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIImageView alloc] init];
        _commentBtn.backgroundColor = [UIColor clearColor];
        _commentBtn.image = [UIImage imageNamed:@"image_article_comment"];
        _commentBtn.contentMode = UIViewContentModeCenter;
        _commentBtn.userInteractionEnabled = YES;
        [_commentBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentButtonClicked)]];
    }
    return _commentBtn;
}

- (UIButton *)deleteBtn1 {
    if (!_deleteBtn1) {
        _deleteBtn1 = [[UIButton alloc] init];
        [_deleteBtn1 setImage:[[UIImage imageNamed:@"image_article_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_deleteBtn1 setTintColor:DPArticleDeleteButtonColor];
        _deleteBtn1.userInteractionEnabled = YES;
        [_deleteBtn1 addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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
        _commentTitle.numberOfLines = 0;
        _commentTitle.lineBreakMode = NSLineBreakByCharWrapping;
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
        _deleteBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteBtn2 addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn2;
}

- (UIButton *)replyBtn {
    if (!_replyBtn) {
        _replyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_replyBtn addTarget:self action:@selector(replyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}

@end
