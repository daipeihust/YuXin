//
//  DPProfileCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPProfileCell.h"
#import "DPProfileItem.h"

typedef NS_ENUM(NSUInteger, DPProfileCellType) {
    DPProfileCellTypeUser,
    DPProfileCellTypeNormal,
    DPProfileCellTypeSwitch
};

@interface DPProfileCell()

@property (nonatomic, assign) DPProfileCellType type;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *title1;
@property (nonatomic, strong) UILabel *title2;
@property (nonatomic, strong) UISwitch *mSwitch;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *separationLine;
@property (nonatomic, strong) UIView *separationLine2;

@end

@implementation DPProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:DPProfileNormalCellReuseIdentifier]) {
            self.type = DPProfileCellTypeNormal;
        }
        else if ([reuseIdentifier isEqualToString:DPProfileUserCellReuseIdentifier]) {
            self.type = DPProfileCellTypeUser;
        }
        else if ([reuseIdentifier isEqualToString:DPProfileSwitchCellReuseIdentifier]) {
            self.type = DPProfileCellTypeSwitch;
        }
        [self initView];
    }
    return self;
}

#pragma mark - ConfigView

- (void)initView {
    [self.contentView addSubview:self.separationLine];
    [self.contentView addSubview:self.separationLine2];
    
    [self.separationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self.separationLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    switch (self.type) {
        case DPProfileCellTypeUser:{
            [self.contentView addSubview:self.userImageView];
            [self.contentView addSubview:self.title1];
            [self.contentView addSubview:self.title2];
            
            self.title1.textAlignment = NSTextAlignmentLeft;
            self.title2.textAlignment = NSTextAlignmentLeft;
            
            [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).with.offset(10);
                make.centerY.equalTo(self.contentView);
                make.height.width.mas_equalTo(60);
            }];
            [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).with.offset(10);
                make.left.equalTo(self.userImageView.mas_right).with.offset(10);
                make.height.mas_equalTo(25);
                make.right.equalTo(self.contentView).with.offset(-10);
            }];
            [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.title1.mas_bottom).with.offset(10);
                make.left.equalTo(self.userImageView.mas_right).with.offset(10);
                make.height.mas_equalTo(25);
                make.right.equalTo(self.contentView).with.offset(-10);
            }];
            break;
        }
        case DPProfileCellTypeNormal:{
            [self.contentView addSubview:self.title1];
            [self.contentView addSubview:self.title2];
            self.title1.textAlignment = NSTextAlignmentLeft;
            self.title2.textAlignment = NSTextAlignmentRight;
            
            [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).with.offset(10);
                make.centerY.equalTo(self.contentView);
            }];
            [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).with.offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
            break;
        }
        case DPProfileCellTypeSwitch:{
            [self.contentView addSubview:self.title1];
            [self.contentView addSubview:self.mSwitch];
            
            [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).with.offset(10);
                make.centerY.equalTo(self.contentView);
            }];
            [self.mSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).with.offset(-10);
                make.centerY.equalTo(self.contentView);
                make.width.mas_equalTo(49);
                make.height.mas_equalTo(31);
            }];
            break;
        }
        default:
            break;
    }
}


#pragma mark - Public Method

- (void)fillDataWith:(DPProfileItem *)item indexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case DPProfileCellTypeUser:
            self.userImageView.image = item.userImage;
            self.title1.text = item.title1;
            self.title2.text = item.title2;
            break;
        case DPProfileCellTypeNormal:
            self.title1.text = item.title1;
            self.title2.text = item.title2;
            break;
        case DPProfileCellTypeSwitch:
            self.title1.text = item.title1;
            
            if ([item.title2 isEqualToString:@"On"]) {
                [self.mSwitch setOn:YES];
            }else {
                [self.mSwitch setOn:NO];
            }
            break;
        default:
            break;
    }
    self.indexPath = indexPath;
}

#pragma mark - Action Method

- (void)switchIsChanged:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchChangeTo:atIndexPath:)]) {
        [self.delegate switchChangeTo:[sender isOn] atIndexPath:self.indexPath];
    }
}

#pragma mark - Getter

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.backgroundColor = [UIColor grayColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 30;
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
        _title2.numberOfLines = 1;
        _title2.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _title2;
}

- (UISwitch *)mSwitch {
    if (!_mSwitch) {
        _mSwitch = [[UISwitch alloc] init];
        [_mSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _mSwitch;
}

- (UIView *)separationLine
{
    if (!_separationLine) {
        _separationLine = [[UIView alloc] init];
        _separationLine.backgroundColor = DPSeparationLineColor;
    }
    return _separationLine;
}

- (UIView *)separationLine2
{
    if (!_separationLine2) {
        _separationLine2 = [[UIView alloc] init];
        _separationLine2.backgroundColor = DPSeparationLineColor;
    }
    return _separationLine2;
}


@end
