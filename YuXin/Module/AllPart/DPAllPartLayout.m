//
//  DPAllPartLayout.m
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPAllPartLayout.h"

@interface DPAllPartLayout()

@property (nonatomic, strong) NSArray *attributeArray;
@property (nonatomic, assign) CGFloat width1;
@property (nonatomic, assign) CGFloat width2;
@property (nonatomic, assign) CGFloat width3;

@end

@implementation DPAllPartLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat space = self.minimumLineSpacing;
    self.width1 = (screenWidth - 3 * space) * 2 / 3;
    self.width2 = (self.width1 - space) / 2;
    self.width3 = (screenWidth - 3 * space) / 2;
    
    UICollectionViewLayoutAttributes *attris1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    attris1.frame = CGRectMake(space, space, self.width1, self.width1);
    
    UICollectionViewLayoutAttributes *attris2 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    attris2.frame = CGRectMake(space * 2 + self.width1, space, self.width2, self.width2);
    
    UICollectionViewLayoutAttributes *attris3 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    attris3.frame = CGRectMake(space * 2 + self.width1, space * 2 + self.width2, self.width2, self.width2);
    
    UICollectionViewLayoutAttributes *attris4 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    attris4.frame = CGRectMake(space, space * 2 + self.width1, self.width2, self.width2);
    
    UICollectionViewLayoutAttributes *attris5 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
    attris5.frame = CGRectMake(space, space * 3 + self.width1 + self.width2, self.width2, self.width2);
    
    UICollectionViewLayoutAttributes *attris6 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
    attris6.frame = CGRectMake(space * 2 + self.width2, space * 2 + self.width1, self.width1, self.width1);
    
    UICollectionViewLayoutAttributes *attris7 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:6 inSection:0]];
    attris7.frame = CGRectMake(space, space * 4 + self.width1 + 2 * self.width2, self.width3, self.width3);
    
    UICollectionViewLayoutAttributes *attris8 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:7 inSection:0]];
    attris8.frame = CGRectMake(space * 2 + self.width3, space * 4 + self.width1 + 2 * self.width2, self.width3, self.width3);
    
    self.attributeArray = @[attris1, attris2, attris3, attris4, attris5, attris6, attris7, attris8];
    
    self.itemSize = CGSizeMake(screenWidth / 2, screenHeight / 3);
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(screenWidth, screenHeight * 2);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat space = self.minimumLineSpacing;
    switch (indexPath.item) {
        case 0:
            attribute.frame = CGRectMake(space, space, self.width1, self.width1);
            break;
        case 1:
            attribute.frame = CGRectMake(space * 2 + self.width1, space, self.width2, self.width2);
            break;
        case 2:
            attribute.frame = CGRectMake(space * 2 + self.width1, space * 2 + self.width2, self.width2, self.width2);
            break;
        case 3:
            attribute.frame = CGRectMake(space, space * 2 + self.width1, self.width2, self.width2);
            break;
        case 4:
            attribute.frame = CGRectMake(space, space * 3 + self.width1 + self.width2, self.width2, self.width2);
            break;
        case 5:
            attribute.frame = CGRectMake(space * 2 + self.width2, space * 2 + self.width1, self.width1, self.width1);;
            break;
        case 6:
            attribute.frame = CGRectMake(space, space * 4 + self.width1 + 2 * self.width2, self.width3, self.width3);
            break;
        case 7:
            attribute.frame = CGRectMake(space * 2 + self.width3, space * 4 + self.width1 + 2 * self.width2, self.width3, self.width3);
            break;
            
        default:
            break;
    }
    return attribute;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributesArray addObject:attributes];
    }
    return attributesArray;
//    return self.attributeArray;
}

@end
