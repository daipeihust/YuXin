//
//  DPTintView.m
//  YuXin
//
//  Created by Dai Pei on 2016/8/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPTintView.h"

@interface DPTintView ()

@property (nonatomic, strong) UILabel *guideLabel;
@property (nonatomic, assign) CGFloat guideLabelWidth;
@property (nonatomic, assign) CGFloat guideLabelHeight;

@end

@implementation DPTintView
@synthesize guide = _guide;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retryViewClicked)]];
    }
    return self;
}

- (instancetype)initWithGuide:(NSString *)guide {
    self = [self init];
    if (self) {
        self.guide = guide;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.guideLabel];
    
    [self.guideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.guideLabelWidth + 1);
        make.height.mas_equalTo(self.guideLabelHeight + 1);
    }];
}

#pragma mark - Privite Method

- (void)retryViewClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tintViewDidClick)]) {
        [self.delegate tintViewDidClick];
    }
}

#pragma mark - Setter

- (void)setGuide:(NSString *)guide {
    _guide = guide;
    self.guideLabel.text = guide;
    CGRect rect = [self.guide boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.guideLabel.font} context:nil];
    self.guideLabelWidth = rect.size.width;
    self.guideLabelHeight = rect.size.height;
    if (self.subviews.count != 0) {
        [self.guideLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(self.guideLabelWidth + 1);
            make.height.mas_equalTo(self.guideLabelHeight + 1);
        }];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Getter

- (UILabel *)guideLabel {
    if (!_guideLabel) {
        _guideLabel = [[UILabel alloc] init];
        _guideLabel.numberOfLines = 0;
        _guideLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = [self.guide boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_guideLabel.font} context:nil];
        self.guideLabelWidth = rect.size.width;
        self.guideLabelHeight = rect.size.height;
        _guideLabel.text = self.guide;
        _guideLabel.textColor = [UIColor grayColor];
    }
    return _guideLabel;
}

@end
