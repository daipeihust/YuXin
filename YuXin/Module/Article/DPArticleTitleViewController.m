//
//  DPArticleTitleViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPArticleTitleViewController.h"

@interface DPArticleTitleViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation DPArticleTitleViewController

#pragma mark - Init

- (instancetype)initWithBoardName:(NSString *)boardName {
    self = [super init];
    if (self) {
        self.boardName = boardName;
        self.title = boardName;
        self.titleArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}




@end
