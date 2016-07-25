//
//  DPLoginViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPLoginViewController.h"
#import "UserHelper.h"
#import "WSProgressHUD+DPExtension.h"

@interface DPLoginTextField : UIView

@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIView *separationLine;


@end

@implementation DPLoginTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = DPLoginTextFieldBGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    
    [self addSubview:self.username];
    [self addSubview:self.password];
    [self addSubview:self.separationLine];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.top.equalTo(self.mas_centerY);
    }];
    [self.separationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Getter

- (UITextField *)username {
    if (!_username) {
        _username = [[UITextField alloc] init];
        _username.placeholder = @"Username";
        _username.backgroundColor = [UIColor clearColor];
        _username.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _username;
}

- (UITextField *)password {
    if (!_password) {
        _password = [[UITextField alloc] init];
        _password.placeholder = @"Password";
        _password.backgroundColor = [UIColor clearColor];
        _password.secureTextEntry = YES;
        _password.clearsOnBeginEditing = YES;
    }
    return _password;
}

- (UIView *)separationLine
{
    if (!_separationLine) {
        _separationLine = [[UIView alloc] init];
        _separationLine.backgroundColor = DPSeparationLineColor;
    }
    return _separationLine;
}

@end

@interface DPLoginViewController()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *backgroundView;
@property (nonatomic, strong) WSProgressHUD *hud;
@property (nonatomic, strong) DPLoginTextField *textField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation DPLoginViewController



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

#pragma mark - ConfigView

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.hud];
    [self.backgroundView addSubview:self.textField];
    [self.backgroundView addSubview:self.titleLabel];
    [self.backgroundView addSubview:self.loginButton];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backgroundView);
        make.width.mas_equalTo(320 * widthRateForFit);
        make.height.mas_equalTo(100 * widthRateForFit);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView);
        make.width.mas_equalTo(200);
        make.bottom.equalTo(self.textField.mas_top).with.offset(-50);
        make.height.mas_equalTo(60);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).with.offset(10);
        make.height.mas_equalTo(50 * widthRateForFit);
        make.width.mas_equalTo(320 * widthRateForFit);
        make.centerX.equalTo(self.backgroundView);
    }];
}

#pragma mark - Action Method

- (void)loginButtonClicked:(UIButton *)sender {
    [self.hud show];
    [self.view setUserInteractionEnabled:NO];
    
//    [[UserHelper sharedInstance] loginWithUserName:self.usernameTextField.text password:self.passwordTextField.text completion:^(NSString *message) {
//        [self.view setUserInteractionEnabled:NO];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.hud dismiss];
//            [WSProgressHUD safeShowString:message];
//        });
//    }];
}

#pragma mark - Privite Method



#pragma mark - Getter

- (WSProgressHUD *)hud {
    if (!_hud) {
        _hud = [[WSProgressHUD alloc] initWithView:self.view];
        [_hud setProgressHUDIndicatorStyle:WSProgressHUDIndicatorMMSpinner];
    }
    return _hud;
}

- (UIScrollView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIScrollView alloc] init];
        _backgroundView.alwaysBounceVertical = YES;
        _backgroundView.contentSize = self.view.frame.size;
        _backgroundView.backgroundColor = DPLoginBackgroundColor;
        _backgroundView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _backgroundView;
}

- (DPLoginTextField *)textField {
    if (!_textField) {
        _textField = [[DPLoginTextField alloc] init];
    }
    return _textField;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"喻信星空";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:35];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _loginButton.backgroundColor = DPLoginButtonColor;
        [_loginButton setTitle:@"Log in" forState:UIControlStateNormal];
        [_loginButton setTintColor:[UIColor whiteColor]];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 7;
    }
    return _loginButton;
}


@end
