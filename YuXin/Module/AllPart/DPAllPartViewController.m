//
//  DPAllPartViewController.m
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPAllPartViewController.h"
#import "DPAllPartLayout.h"
#import "VVSpringCollectionViewFlowLayout.h"
#import "DPAllPartCell.h"
#import "DPBoardViewController.h"

@interface DPAllPartViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *partNameArray;
@property (nonatomic, strong) NSArray<UIImage *> *partImageArray;

@end

@implementation DPAllPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = @"全部版面";
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(allPartVCDidAppear)]) {
        [self.delegate allPartVCDidAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(allPartVCWillDisappear)]) {
        [self.delegate allPartVCWillDisappear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(allPartVCDidDisappear)]) {
        [self.delegate allPartVCDidDisappear];
    }
}

#pragma mark - ConfigView

- (void)initView {
    self.view.backgroundColor = DPBackgroundColor;
    self.collectionView.backgroundColor = DPBackgroundColor;
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DPBoardViewController *viewController = [[DPBoardViewController alloc] initWithBoardType:(DPBoardType)indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DPAllPartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DPAllPartCellReuseIdentifier forIndexPath:indexPath];
    [cell fillDataWithPartImage:self.partImageArray[indexPath.row] partName:self.partNameArray[indexPath.row]];
    return cell;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        VVSpringCollectionViewFlowLayout *layout = [[VVSpringCollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(screenWidth, 60);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[DPAllPartCell class] forCellWithReuseIdentifier:DPAllPartCellReuseIdentifier];
    }
    return _collectionView;
}

- (NSArray *)partNameArray {
    if (!_partNameArray) {
        _partNameArray = @[@"喻信星空", @"电信风采", @"数字时代", @"学术科学", @"人文艺术", @"纯真时代", @"休闲娱乐", @"时事快递"];
    }
    return _partNameArray;
}

- (NSArray *)partImageArray {
    if (!_partImageArray) {
        _partImageArray = @[[UIImage imageNamed:@"image_allpart_part1"],
                            [UIImage imageNamed:@"image_allpart_part2"],
                            [UIImage imageNamed:@"image_allpart_part3"],
                            [UIImage imageNamed:@"image_allpart_part4"],
                            [UIImage imageNamed:@"image_allpart_part5"],
                            [UIImage imageNamed:@"image_allpart_part6"],
                            [UIImage imageNamed:@"image_allpart_part7"],
                            [UIImage imageNamed:@"image_allpart_part8"]];
    }
    return _partImageArray;
}


@end
