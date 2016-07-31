//
//  DPProfileViewController.h
//  YuXin
//
//  Created by Dai Pei on 16/7/22.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPProfileViewControllerDelegate;

@interface DPProfileViewController : UIViewController

@property (nonatomic, weak) id<DPProfileViewControllerDelegate> delegate;

@end

@protocol DPProfileViewControllerDelegate <NSObject>

- (void)profileVCDidAppear;
- (void)profileVCWillDisappear;
- (void)profileVCDidDisappear;

@end
