//
//  DPArticleDetailViewController.h
//  YuXin
//
//  Created by Dai Pei on 16/7/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPArticleDetailViewControllerDelegate;

@interface DPArticleDetailViewController : UIViewController

@property (nonatomic, weak) id<DPArticleDetailViewControllerDelegate> delegate;

- (instancetype)initWithBoard:(NSString *)boardName file:(NSString *)fileName index:(NSInteger)index;

@end

@protocol DPArticleDetailViewControllerDelegate <NSObject>

- (void)deleteArticleAtIndex:(NSInteger)index;

@end
