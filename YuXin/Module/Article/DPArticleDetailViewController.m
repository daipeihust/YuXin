//
//  DPArticleDetailViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleDetailViewController.h"
#import "DPArticleDetailCell.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "WSProgressHUD+DPExtension.h"
#import "DPUserInfoViewController.h"
#import "DPTintView.h"

@protocol DPCommentTextPlaceDelegate;

@interface DPCommentTextPlace : UIView

@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *separationLine;
@property (nonatomic, weak) id<DPCommentTextPlaceDelegate> delegate;
@property (nonatomic, assign) NSInteger replyArticleIndex;

@end

@protocol DPCommentTextPlaceDelegate <NSObject>

- (void)sendButtonDidClicked:(UIButton *)sender;

@end

@implementation DPCommentTextPlace

- (instancetype)init {
    self = [super init];
    if (self) {
        self.replyArticleIndex = 0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.commentTextField];
    [self addSubview:self.sendButton];
    [self addSubview:self.separationLine];
    
    [self.commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(2, 5, 2, 60));
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-5);
        make.top.equalTo(self).with.offset(2);
        make.bottom.equalTo(self).with.offset(-2);
        make.left.equalTo(self.commentTextField.mas_right).with.offset(5);
    }];
    [self.separationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)buttonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendButtonDidClicked:)]) {
        [self.delegate sendButtonDidClicked:sender];
    }
}

#pragma mark - Getter

- (UITextField *)commentTextField {
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] init];
        _commentTextField.placeholder = @"说点什么吧...";
    }
    return _commentTextField;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        _sendButton.enabled = NO;
        [_sendButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIView *)separationLine {
    if (!_separationLine) {
        _separationLine = [[UIView alloc] init];
        _separationLine.backgroundColor = DPTabBarTopLineColor;
    }
    return _separationLine;
}

@end

typedef NS_ENUM(NSUInteger, DPArticleType) {
    DPArticleTypeDetail = 0,
    DPArticleTypeComment = 1
};

@interface DPArticleDetailViewController() <UITableViewDelegate, UITableViewDataSource, DPArticleDetailCellDelegate, DPCommentTextPlaceDelegate, UITextFieldDelegate, DPTintViewDelegate>

@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleArray;
@property (nonatomic, strong) DPTintView *tintView;
@property (nonatomic, strong) WSProgressHUD *hud;
@property (nonatomic, strong) DPCommentTextPlace *commentTextPlace;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSString *fileToBeDelete;
@property (nonatomic, strong) NSString *fileToBeReprint;
@property (nonatomic, strong) UIAlertView *deleteAlert;
@property (nonatomic, assign) NSInteger index;

@end

@implementation DPArticleDetailViewController

#pragma mark - Init

- (instancetype)initWithBoard:(NSString *)boardName file:(NSString *)fileName index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.boardName = boardName;
        self.fileName = fileName;
        self.index = index;
        self.title = @"详情";
        self.articleArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ConfigViews];
    [self initData];
    [self registerForKeyboardNotifications];
    [self registerTextFieldNotifications];
}

#pragma mark - ConfigUI

- (void)ConfigViews {
    self.view.backgroundColor = DPBackgroundColor;
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.hud];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.tintView];
    [self.contentView addSubview:self.commentTextPlace];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-44);
    }];
    [self.tintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.commentTextPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - DPTintViewDelegate

- (void)tintViewDidClick {
    [self initData];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.commentTextPlace.replyArticleIndex == -1) {
        textField.placeholder = [NSString stringWithFormat:@"转载到哪个板块？"];
    }else {
        YuXinArticle *replyArticle = self.articleArray[self.commentTextPlace.replyArticleIndex];
        NSString *author = replyArticle.author;
        textField.placeholder = [NSString stringWithFormat:@"回复:%@", author];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.commentTextPlace.commentTextField.text = @"";
    self.commentTextPlace.replyArticleIndex = 0;
    self.commentTextPlace.commentTextField.placeholder = @"说点什么吧...";
}

#pragma mark - DPCommentTextPlaceDelegate

- (void)sendButtonDidClicked:(UIButton *)sender {
    sender.enabled = NO;
    if (self.commentTextPlace.replyArticleIndex == -1) {
        __weak typeof(self) weakSelf = self;
        [[YuXinSDK sharedInstance] reprintArticleWithFile:self.fileToBeReprint from:self.boardName to:self.commentTextPlace.commentTextField.text completion:^(NSString *error, NSArray *responseModels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [WSProgressHUD safeShowString:@"转载成功"];
                    [weakSelf headerRefresh];
                }else {
                    [WSProgressHUD safeShowString:error];
                }
            });
        }];
    }else {
        YuXinArticle *mainArticle = self.articleArray[0];
        YuXinArticle *currentArticle = self.articleArray[self.commentTextPlace.replyArticleIndex];
        NSString *footer = [self createFooterWithArticleIndex:self.commentTextPlace.replyArticleIndex];
        NSMutableString *content = [NSMutableString stringWithString:self.commentTextPlace.commentTextField.text];
        [content appendString:footer];
        [self.hud show];
        [self.view setUserInteractionEnabled:NO];
        __weak typeof(self) weakSelf = self;
        [[YuXinSDK sharedInstance] commentArticle:mainArticle.title content:content board:self.boardName canReply:YES file:currentArticle.fileName completion:^(NSString *error, NSArray *responseModels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.hud dismiss];
                [weakSelf.view setUserInteractionEnabled:YES];
                if (!error) {
                    [WSProgressHUD safeShowString:@"评论成功"];
                    weakSelf.commentTextPlace.commentTextField.text = @"";
                    [weakSelf headerRefresh];
                }else {
                    [WSProgressHUD safeShowString:error];
                }
            });
        }];
        [weakSelf.commentTextPlace.commentTextField resignFirstResponder];
    }
}

#pragma mark - DPArticleDetailCellDelegate

- (void)userImageViewDidClick:(NSString *)userID {
    DPUserInfoViewController *viewController = [[DPUserInfoViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)reprintButtonDidClick:(NSString *)fileName {
    self.fileToBeReprint = fileName;
    self.commentTextPlace.replyArticleIndex = -1;
    [self.commentTextPlace.commentTextField becomeFirstResponder];
}

- (void)commentButtonDidClick {
    self.commentTextPlace.replyArticleIndex = 0;
    YuXinArticle *article = self.articleArray[0];
    self.commentTextPlace.commentTextField.placeholder = [NSString stringWithFormat:@"回复:%@", article.author];
    [self.commentTextPlace.commentTextField becomeFirstResponder];
}

- (void)replyButtonDidClick:(NSUInteger)index {
    self.commentTextPlace.replyArticleIndex = index + 1;
    YuXinArticle *article = self.articleArray[index + 1];
    self.commentTextPlace.commentTextField.placeholder = [NSString stringWithFormat:@"回复:%@", article.author];
    [self.commentTextPlace.commentTextField becomeFirstResponder];
}

- (void)deleteButtonDidClick:(NSString *)fileName {
    self.fileToBeDelete = fileName;
    [self.deleteAlert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        __weak typeof(self) weakSelf = self;
        [[YuXinSDK sharedInstance] deleteArticleWithBoard:self.boardName file:self.fileToBeDelete completion:^(NSString *error, NSArray *responseModels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [WSProgressHUD safeShowString:@"删除成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteArticleAtIndex:)]) {
                        [weakSelf.delegate deleteArticleAtIndex:weakSelf.index];
                    }
                }else {
                    [WSProgressHUD safeShowString:error];
                }
            });
        }];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DPArticleTypeDetail) {
        return [tableView fd_heightForCellWithIdentifier:DPArticleDetailCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell fillDataWithModel:self.articleArray[indexPath.row + indexPath.section]];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:DPArticleDetailCellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell fillDataWithModel:self.articleArray[indexPath.row + indexPath.section]];
        }];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber;
    switch (section) {
        case DPArticleTypeDetail:
            rowNumber = (self.articleArray.count)? 1 : 0;
            break;
        case DPArticleTypeComment:
            rowNumber = (self.articleArray.count)? self.articleArray.count - 1 : 0;
            break;
        default:
            break;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPArticleDetailCell *cell;
    switch (indexPath.section) {
        case DPArticleTypeDetail:
            cell = [tableView dequeueReusableCellWithIdentifier:DPArticleDetailCellReuseIdentifier];
            break;
        case DPArticleTypeComment:
            cell = [tableView dequeueReusableCellWithIdentifier:DPArticleCommentCellReuseIdentifier];
            break;
        default:
            break;
    }
    [cell fillDataWithModel:self.articleArray[indexPath.row + indexPath.section]];
    cell.delegate = self;
    cell.index = indexPath.row;
    return cell;
}

#pragma mark - Privite Method

- (void)registerTextFieldNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (NSString *)createFooterWithArticleIndex:(NSUInteger)index {
    NSString *result;
    YuXinArticle *article = self.articleArray[index];
    NSString *userIDAndName = article.userIDAndName;
    NSString *content = article.displayContent;
    NSMutableString *tmp = [NSMutableString stringWithFormat:@"\n【 在 %@ 的大作中提到: 】\n:", userIDAndName];
    [tmp appendString:content];
    result = [tmp copy];
    return result;
}

- (void)initData {
    self.tintView.hidden = YES;
    [self.hud show];
    [self.view setUserInteractionEnabled:NO];
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticlesWithBoard:self.boardName file:self.fileName completion:^(NSString *error, NSArray *responseModels) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.hud dismiss];
            [weakSelf.view setUserInteractionEnabled:YES];
        });
        if (!error) {
            weakSelf.articleArray = [NSMutableArray arrayWithArray:responseModels];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tableView.hidden = NO;
                weakSelf.commentTextPlace.hidden = NO;
                [weakSelf.tableView reloadData];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WSProgressHUD safeShowString:error];
                [weakSelf.tintView setGuide:@"网络似乎有问题\n点击屏幕重新加载"];
                weakSelf.tintView.hidden = NO;
            });
        }
    }];
}

#pragma mark - Action Method

- (void)headerRefresh {
    __weak typeof(self) weakSelf = self;
    [[YuXinSDK sharedInstance] fetchArticlesWithBoard:self.boardName file:self.fileName completion:^(NSString *error, NSArray *responseModels) {
        if (!error) {
            weakSelf.articleArray = [NSMutableArray arrayWithArray:responseModels];
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WSProgressHUD safeShowString:error];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.with.offset(-kbSize.height);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    if (![self.commentTextPlace.commentTextField.text isEqualToString:@""]) {
        self.commentTextPlace.sendButton.enabled = YES;
    }else {
        self.commentTextPlace.sendButton.enabled = NO;
    }
}

- (void)backgroundDidTap:(UITapGestureRecognizer *)recognizer {
    if ([self.commentTextPlace.commentTextField isFirstResponder]) {
        [self.commentTextPlace.commentTextField resignFirstResponder];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = DPBackgroundColor;
        _tableView.hidden = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[DPArticleDetailCell class] forCellReuseIdentifier:DPArticleDetailCellReuseIdentifier];
        [_tableView registerClass:[DPArticleDetailCell class] forCellReuseIdentifier:DPArticleCommentCellReuseIdentifier];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        header.automaticallyChangeAlpha = YES;
        [header setTitle:@"玩命加载中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
    }
    return _tableView;
}

- (WSProgressHUD *)hud {
    if (!_hud) {
        _hud = [[WSProgressHUD alloc] initWithView:self.view];
        [_hud setProgressHUDIndicatorStyle:WSProgressHUDIndicatorMMSpinner];
    }
    return _hud;
}

- (DPCommentTextPlace *)commentTextPlace {
    if (!_commentTextPlace) {
        _commentTextPlace = [[DPCommentTextPlace alloc] init];
        _commentTextPlace.hidden = YES;
        _commentTextPlace.delegate = self;
        _commentTextPlace.commentTextField.delegate = self;
    }
    return _commentTextPlace;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidTap:)]];
    }
    return _contentView;
}

- (UIAlertView *)deleteAlert {
    if (!_deleteAlert) {
        _deleteAlert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"是否删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    }
    return _deleteAlert;
}

- (DPTintView *)tintView {
    if (!_tintView) {
        _tintView = [[DPTintView alloc] init];
        _tintView.delegate = self;
        _tintView.hidden = YES;
    }
    return _tintView;
}

@end
