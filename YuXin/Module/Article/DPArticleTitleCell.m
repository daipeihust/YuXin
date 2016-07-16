//
//  DPArticleTitleCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleTitleCell.h"

@interface DPArticleTitleCell()

@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *summaryLabel;

@end

@implementation DPArticleTitleCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutUI];
    }
    return self;
}

#pragma mark - Public Method

- (void)fillDataWithModel:(YuXinTitle *)model {
//    YuXinTitle *model2 = [self refineModel:model];
    self.titleLabel.text = model.name;
    self.authorLabel.text = model.author;
    self.commentLabel.text = model.replyNum;
    self.timeLabel.text = model.date;
    self.summaryLabel.text = model.summary;
    [self relayoutUI];
}

#pragma mark - ConfigViews

- (void)layoutUI {
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.summaryLabel];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(10);
        make.width.height.mas_equalTo(30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImageView);
        make.left.equalTo(self.userImageView.mas_right).with.offset(10);
        make.height.mas_equalTo(25);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(100);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(100);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(100);
    }];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)relayoutUI {
    
}

#pragma mark - Privite Method

- (YuXinTitle *)refineModel:(YuXinTitle *)model {
    NSString *tmpDate = model.date;
    [tmpDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tmpDate = [tmpDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@">>>>>>>>%@", tmpDate);
    model.date = tmpDate;
    return model;
}

#pragma mark - Getter

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.backgroundColor = [UIColor grayColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 15;
    }
    return _userImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DPFirstLevelTitleColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = DPSecondLevelTitleColor;
        _authorLabel.font = [UIFont systemFontOfSize:10];
        _authorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _authorLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = DPSecondLevelTitleColor;
        _commentLabel.font = [UIFont systemFontOfSize:10];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _commentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = DPSecondLevelTitleColor;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)summaryLabel {
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.textColor = DPBodyTextColor;
        _summaryLabel.font = [UIFont systemFontOfSize:20];
        _summaryLabel.textAlignment = NSTextAlignmentLeft;
        _summaryLabel.numberOfLines = 0;
    }
    return _summaryLabel;
}

@end
