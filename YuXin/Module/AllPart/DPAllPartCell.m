//
//  DPAllPartCell.m
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPAllPartCell.h"

@interface DPAllPartCell()

@property (nonatomic, strong) UIImageView *partImageView;
@property (nonatomic, strong) UILabel *partNameLabel;
@property (nonatomic, strong) UIView *separationLine1;
@property (nonatomic, strong) UIView *separationLine2;

@end

@implementation DPAllPartCell


#pragma mark - ConfigView



#pragma mark - Public Method

- (void)fillDataWithPartImage:(UIImage *)image partName:(NSString *)name {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.contentView addSubview:self.partImageView];
    [self.contentView addSubview:self.partNameLabel];
    [self.contentView addSubview:self.separationLine1];
    [self.contentView addSubview:self.separationLine2];
    
    [self.partImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [self.partNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partImageView.mas_right).with.offset(20);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [self.separationLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.separationLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.partImageView.image = image;
    self.partNameLabel.text = name;
}

#pragma mark - Getter

- (UIImageView *)partImageView {
    if (!_partImageView) {
        _partImageView = [[UIImageView alloc] init];
        
    }
    return _partImageView;
}

- (UILabel *)partNameLabel {
    if (!_partNameLabel) {
        _partNameLabel = [[UILabel alloc] init];
        _partNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _partNameLabel;
}

- (UIView *)separationLine1
{
    if (!_separationLine1) {
        _separationLine1 = [[UIView alloc] init];
        _separationLine1.backgroundColor = DPSeparationLineColor;
    }
    return _separationLine1;
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
