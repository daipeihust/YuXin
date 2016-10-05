//
//  DPPostArticleViewController.m
//  YuXin
//
//  Created by Dai Pei on 2016/8/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPPostArticleViewController.h"
#import "UserHelper.h"
#import "WSProgressHUD+DPExtension.h"
#import "UIDevice+DPExtension.h"
#import "YuXinSDK.h"

typedef NS_ENUM(NSInteger, DPPostArticleButtonType) {
    DPPostArticleButtonTypePost,
    DPPostArticleButtonTypeCanlce
};

@interface DPPostArticleViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UITextView *titleTV;
@property (nonatomic, strong) UILabel *placeHolderLabel1;
@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) UILabel *placeHolderLabel2;

@end

@implementation DPPostArticleViewController

- (instancetype)initWithBoardName:(NSString *)boardName {
    self = [super init];
    if (self) {
        self.boardName = boardName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self registerNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ConfigViews

- (void)initView {
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidTap)]];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.postButton];
    [self.contentView addSubview:self.cancleButton];
    [self.contentView addSubview:self.titleTV];
    [self.titleTV addSubview:self.placeHolderLabel1];
    [self.contentView addSubview:self.contentTV];
    [self.contentTV addSubview:self.placeHolderLabel2];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-20 * heightRateForFit);
        make.height.mas_equalTo(320 * widthRateForFit);
        make.width.mas_equalTo(250 * widthRateForFit);
    }];
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-25 * widthRateForFit);
        make.top.equalTo(self.contentView).with.offset(8);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(25 * widthRateForFit);
        make.top.equalTo(self.contentView).with.offset(8);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    [self.titleTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.postButton.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(37);
        make.width.mas_equalTo(235 * widthRateForFit);
    }];
    [self.placeHolderLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTV).with.offset(8);
        make.left.equalTo(self.titleTV).with.offset(5);
        make.width.equalTo(self.titleTV);
        make.height.mas_equalTo(20);
    }];
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTV.mas_bottom).with.offset(2);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    [self.placeHolderLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTV).with.offset(8);
        make.left.equalTo(self.contentTV).with.offset(5);
        make.width.equalTo(self.contentTV);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.contentTV) {
        if (![textView.text isEqualToString:@""]) {
            self.placeHolderLabel2.hidden = YES;
        }else {
            self.placeHolderLabel2.hidden = NO;
        }
    }
    else if (textView == self.titleTV) {
        if (![textView.text isEqualToString:@""]) {
            self.placeHolderLabel1.hidden = YES;
        }else {
            self.placeHolderLabel1.hidden = NO;
        }
    }
    if (self.placeHolderLabel1.hidden && self.placeHolderLabel2.hidden) {
        self.postButton.enabled = YES;
    }
}

#pragma mark - Action Method

- (void)buttonClicked:(UIButton *)sender {
    [self.titleTV resignFirstResponder];
    [self.contentTV resignFirstResponder];
    switch (sender.tag) {
        case DPPostArticleButtonTypePost: {
            __weak typeof(self) weakSelf = self;
            NSMutableString *postContent = [NSMutableString stringWithString:self.contentTV.text];
            if ([[UserHelper sharedInstance] showSignature]) {
                NSString *detailModelName = [[UIDevice currentDevice] realModelName];
                [postContent appendString:[NSString stringWithFormat:@"\n\n来自：%@", detailModelName]];
            }
            [[YuXinSDK sharedInstance] postArticleWithContent:postContent title:self.titleTV.text board:self.boardName canReply:YES userID:[[UserHelper sharedInstance] userName] completion:^(NSString *error, NSArray *responseModels) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(articleDidPost)]) {
                            [weakSelf.delegate articleDidPost];
                        }
                        [self dismissViewControllerAnimated:YES completion:^{
                            [WSProgressHUD safeShowString:@"发帖成功"];
                        }];
                    });
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [WSProgressHUD safeShowString:error];
                    });
                }
            }];
            break;
        }
        case DPPostArticleButtonTypeCanlce:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)backgroundDidTap {
    [self.titleTV resignFirstResponder];
    [self.contentTV resignFirstResponder];
}

- (void)keyboardDidAppear:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(320 * widthRateForFit);
        make.width.mas_equalTo(250 * widthRateForFit);
        make.bottom.equalTo(self.view).with.offset(-kbSize.height - 10 * widthRateForFit);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidDisappear:(NSNotification *)notification {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-20 * heightRateForFit);
        make.height.mas_equalTo(320 * widthRateForFit);
        make.width.mas_equalTo(250 * widthRateForFit);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Privite Method

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10.f;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _postButton.enabled = NO;
        [_postButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_postButton setTitle:@"发帖" forState:UIControlStateNormal];
        _postButton.tag = DPPostArticleButtonTypePost;
        [_postButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.tag = DPPostArticleButtonTypeCanlce;
        [_cancleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (UILabel *)placeHolderLabel2 {
    if (!_placeHolderLabel2) {
        _placeHolderLabel2 = [[UILabel alloc] init];
        _placeHolderLabel2.text = @"帖子正文";
        _placeHolderLabel2.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }
    return _placeHolderLabel2;
}

- (UITextView *)contentTV {
    if (!_contentTV) {
        _contentTV = [[UITextView alloc] init];
        _contentTV.delegate = self;
        _contentTV.font = self.placeHolderLabel2.font;
        _contentTV.layer.cornerRadius = 5;
        _contentTV.layer.masksToBounds = YES;
        _contentTV.layer.borderColor = DPImageBorderColor.CGColor;
        _contentTV.layer.borderWidth = 1;
    }
    return _contentTV;
}

- (UILabel *)placeHolderLabel1 {
    if (!_placeHolderLabel1) {
        _placeHolderLabel1 = [[UILabel alloc] init];
        _placeHolderLabel1.text = @"标题...";
        _placeHolderLabel1.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }
    return _placeHolderLabel1;
}

- (UITextView *)titleTV {
    if (!_titleTV) {
        _titleTV = [[UITextView alloc] init];
        _titleTV.delegate = self;
        _titleTV.font = self.placeHolderLabel1.font;
        _titleTV.layer.cornerRadius = 5;
        _titleTV.layer.masksToBounds = YES;
        _titleTV.layer.borderColor = DPImageBorderColor.CGColor;
        _titleTV.layer.borderWidth = 1;
    }
    return _titleTV;
}

@end
