//
//  DPFriendListCell.m
//  YuXin
//
//  Created by Dai Pei on 2016/8/7.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPFriendListCell.h"
#import "YuXinModel.h"

@interface DPFriendListCell ()

@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *nicknameLabel;

@end

@implementation DPFriendListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initView];
}

#pragma mark - Public Method

- (void)fillDataWithModel:(YuXinFriend *)model {
    self.usernameLabel.text = model.userID;
    self.nicknameLabel.text = model.nickName;
}

#pragma mark - Privite Method

- (void)initView {
    [self.contentView addSubview:self.userImage];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.nicknameLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.userImage.mas_right).with.offset(10);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameLabel.mas_bottom);
        make.left.equalTo(self.usernameLabel);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - Getter

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [[UIImageView alloc] init];
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.cornerRadius = 25;
        _userImage.backgroundColor = [UIColor grayColor];
        _userImage.image = [UIImage imageNamed:@"image_user_avatar"];
        _userImage.layer.borderWidth = 1.0f;
        _userImage.layer.borderColor = DPImageBorderColor.CGColor;
    }
    return _userImage;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.numberOfLines = 1;
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _usernameLabel;
}

- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.numberOfLines = 1;
        _nicknameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    return _nicknameLabel;
}

@end
