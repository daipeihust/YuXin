//
//  DPBoardCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPBoardCell.h"
#import "YuXinModel.h"

@class YuXinBoard;

@interface DPBoardCell()

@property (nonatomic, strong) UILabel *boardName;
@property (nonatomic, strong) UILabel *boardDescription;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIImageView *unlikeImageView;
@property (nonatomic, strong) YuXinBoard *model;

@end

@implementation DPBoardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initView];
}

#pragma mark - ConfigView

- (void)initView {
    self.backgroundView.backgroundColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.boardName];
    [self.contentView addSubview:self.boardDescription];
    [self.contentView addSubview:self.likeImageView];
    [self.contentView addSubview:self.unlikeImageView];
    
    [self.boardName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    [self.boardDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boardName.mas_bottom).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [self.unlikeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
}

#pragma mark - Public Method

- (void)fileDataWithModel:(YuXinBoard *)model {
    self.model = model;
    self.boardName.text = model.boardName;
    self.boardDescription.text = model.boardTitle;
}

- (void)setLike:(BOOL)like {
    self.likeImageView.hidden = !like;
    self.unlikeImageView.hidden = like;
}

#pragma mark - Getter

- (UILabel *)boardName {
    if (!_boardName) {
        _boardName = [[UILabel alloc] init];
        _boardName.numberOfLines = 1;
        _boardName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _boardName.textColor = DPFirstLevelTitleColor;
        _boardName.textAlignment = NSTextAlignmentLeft;
    }
    return _boardName;
}

- (UILabel *)boardDescription {
    if (!_boardDescription) {
        _boardDescription = [[UILabel alloc] init];
        _boardDescription.numberOfLines = 1;
        _boardDescription.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _boardDescription.textColor = DPBodyTextColor;
        _boardName.textAlignment = NSTextAlignmentLeft;
    }
    return _boardDescription;
}

- (UIImageView *)likeImageView {
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.contentMode = UIViewContentModeScaleToFill;
        [_likeImageView setImage:[[UIImage imageNamed:@"image_board_like"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        _likeImageView.tintColor = DPBoardLikeTintColor;
        _likeImageView.hidden = YES;
    }
    return _likeImageView;
}

- (UIImageView *)unlikeImageView {
    if (!_unlikeImageView) {
        _unlikeImageView = [[UIImageView alloc] init];
        _unlikeImageView.contentMode = UIViewContentModeScaleToFill;
        [_unlikeImageView setImage:[UIImage imageNamed:@"image_board_unlike"]];
        _unlikeImageView.hidden = YES;
    }
    return _unlikeImageView;
}

@end
