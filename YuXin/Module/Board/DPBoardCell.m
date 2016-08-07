//
//  DPBoardCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/20.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPBoardCell.h"

@interface DPBoardCell()

@property (nonatomic, strong) UILabel *boardName;
@property (nonatomic, strong) UILabel *boardDescription;
@property (nonatomic, strong) YuXinBoard *model;

@end

@implementation DPBoardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"board width:%f height:%f boardName:%@", self.frame.size.width, self.frame.size.height, self.boardName.text);
}

#pragma mark - ConfigView

- (void)initView {
    self.backgroundView.backgroundColor = [UIColor grayColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.boardName];
    [self.contentView addSubview:self.boardDescription];
    
    [self.boardName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
    }];
    [self.boardDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boardName.mas_bottom).with.offset(10);
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-5);
    }];
}

#pragma mark - Public Method

- (void)fileDataWithModel:(YuXinBoard *)model {
    self.model = model;
    self.boardName.text = model.boardName;
    self.boardDescription.text = model.boardTitle;
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

@end
