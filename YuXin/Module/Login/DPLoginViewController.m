//
//  DPLoginViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPLoginViewController.h"
#import "UserHelper.h"

typedef NS_ENUM(NSUInteger, LoginTextViewType) {
    LoginTextViewTypeUsername,
    LoginTextViewTypePassword
};

@interface DPLoginTextView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation DPLoginTextView


#pragma mark - Getter

- (UILabel *)titleLabel {
    if (_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end

@interface DPLoginViewController()

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
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
    
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(200);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.view);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).with.offset(10);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.view);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(20);
        make.width.mas_equalTo(100);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Action Method

- (void)loginButtonClicked:(UIButton *)sender {
    
    [[UserHelper sharedInstance] loginWithUserName:self.usernameTextField.text password:self.passwordTextField.text completion:^(NSString *message) {
        
    }];
}

#pragma mark - Getter

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] init];
        _usernameTextField.placeholder = @"username";
        _usernameTextField.layer.borderWidth = 1;
        _usernameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"password";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.layer.borderWidth = 1;
        _passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    return _loginButton;
}

@end
