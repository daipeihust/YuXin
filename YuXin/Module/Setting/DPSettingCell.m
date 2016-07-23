//
//  DPSettingCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPSettingCell.h"
#import "DPSettingItem.h"

typedef NS_ENUM(NSUInteger, DPSettingCellType) {
    DPSettingCellTypeUser,
    DPSettingCellTypeNormal,
    DPSettingCellTypeSwitch
};

@interface DPSettingCell()

@property (nonatomic, assign) DPSettingCellType type;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *title1;
@property (nonatomic, strong) UILabel *title2;
@property (nonatomic, strong) UISwitch *mSwitch;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation DPSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:DPSettingNormalCellReuseIdentifier]) {
            self.type = DPSettingCellTypeNormal;
        }
        else if ([reuseIdentifier isEqualToString:DPSettingUserCellReuseIdentifier]) {
            self.type = DPSettingCellTypeUser;
        }
        else if ([reuseIdentifier isEqualToString:DPSettingSwitchCellReuseIdentifier]) {
            self.type = DPSettingCellTypeSwitch;
        }
        [self initView];
    }
    return self;
}

#pragma mark - ConfigView

- (void)initView {
    switch (self.type) {
        case DPSettingCellTypeUser:{
            [self addSubview:self.userImageView];
            [self addSubview:self.title1];
            [self addSubview:self.title2];
            
            [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(10);
                make.centerY.equalTo(self);
                make.height.width.mas_equalTo(60);
            }];
            [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(10);
                make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            }];
            [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.title1.mas_bottom).with.offset(10);
                make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            }];
            break;
        }
        case DPSettingCellTypeNormal:{
            [self addSubview:self.title1];
            [self addSubview:self.title2];
            self.title1.textAlignment = NSTextAlignmentLeft;
            self.title2.textAlignment = NSTextAlignmentRight;
            
            [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(10);
                make.centerY.equalTo(self);
            }];
            [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-10);
                make.centerY.equalTo(self);
            }];
            break;
        }
        case DPSettingCellTypeSwitch:{
            [self addSubview:self.title1];
            [self addSubview:self.mSwitch];
            
            [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(10);
                make.centerY.equalTo(self);
            }];
            [self.mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-10);
                make.centerY.equalTo(self);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(20);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Public Method

- (void)fillDataWith:(DPSettingItem *)item {
    switch (self.type) {
        case DPSettingCellTypeUser:
            self.userImageView.image = item.userImage;
            self.title1.text = item.title1;
            self.title2.text = item.title2;
            break;
        case DPSettingCellTypeNormal:
            self.title1.text = item.title1;
            self.title2.text = item.title2;
            break;
        case DPSettingCellTypeSwitch:
            self.title1.text = item.title1;
            if ([self.title2.text isEqualToString:@"On"]) {
                [self.mSwitch setOn:YES];
            }else {
                [self.mSwitch setOn:NO];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Getter

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.backgroundColor = [UIColor grayColor];
    }
    return _userImageView;
}

- (UILabel *)title1 {
    if (!_title1) {
        _title1 = [[UILabel alloc] init];
        _title1.numberOfLines = 1;
        _title1.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    return _title1;
}

- (UILabel *)title2 {
    if (!_title2) {
        _title2 = [[UILabel alloc] init];
        _title2.numberOfLines = 2;
        _title2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _title2;
}

- (UISwitch *)mSwitch {
    if (!_mSwitch) {
        _mSwitch = [[UISwitch alloc] init];
    }
    return _mSwitch;
}


@end
