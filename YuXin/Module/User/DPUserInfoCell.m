//
//  DPUserInfoCell.m
//  YuXin
//
//  Created by Dai Pei on 2016/8/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPUserInfoCell.h"

typedef NS_ENUM(NSInteger, DPUserInfoCellType) {
    DPUserInfoCellTypeNormal,
    DPUserInfoCellTypeImage
};

@interface DPUserInfoCell ()

@property (nonatomic, assign) DPUserInfoCellType cellType;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *userImageView;

@end

@implementation DPUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:DPUserInfoImageCellReuseIdentifier]) {
            self.cellType = DPUserInfoCellTypeImage;
        }else if ([reuseIdentifier isEqualToString:DPUserInfoNormalCellReuseIdentifier]) {
            self.cellType = DPUserInfoCellTypeNormal;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.width.mas_equalTo(screenWidth / 2);
        make.height.mas_equalTo(30);
    }];
    
    switch (self.cellType) {
        case DPUserInfoCellTypeNormal: {
            [self.contentView addSubview:self.infoLabel];
            [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView).with.offset(-10);
                make.width.mas_equalTo(screenWidth / 2);
                make.height.mas_equalTo(30);
            }];
            break;
        }
        case DPUserInfoCellTypeImage: {
            [self.contentView addSubview:self.userImageView];
            [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).with.offset(-10);
                make.centerY.equalTo(self.contentView);
                make.height.width.mas_equalTo(60);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Public Method

- (void)fillDataWith:(NSDictionary *)dic {
    self.titleLabel.text = [dic.allKeys firstObject];
    self.infoLabel.text = [dic.allValues firstObject];
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 1;
        _infoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _infoLabel.textColor = [UIColor grayColor];
        _infoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _infoLabel;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.backgroundColor = [UIColor grayColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 30;
        _userImageView.image = [UIImage imageNamed:@"image_user_avatar"];
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userImageView.layer.borderWidth = 1.f;
        _userImageView.layer.borderColor = DPImageBorderColor.CGColor;
    }
    return _userImageView;
}

@end
