//
//  DPPostArticleViewController.h
//  YuXin
//
//  Created by Dai Pei on 2016/8/16.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPPostArticleViewControllerDelegate;

@interface DPPostArticleViewController : UIViewController

@property (nonatomic, weak) id<DPPostArticleViewControllerDelegate> delegate;

- (instancetype)initWithBoardName:(NSString *)boardName;

@end

@protocol DPPostArticleViewControllerDelegate <NSObject>

@optional
- (void)articleDidPost;

@end