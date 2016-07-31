//
//  DPAllPartViewController.h
//  YuXin
//
//  Created by Dai Pei on 16/7/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPAllPartViewControllerDelegate;

@interface DPAllPartViewController : UIViewController

@property (nonatomic, weak) id<DPAllPartViewControllerDelegate> delegate;

@end

@protocol DPAllPartViewControllerDelegate <NSObject>

- (void)allPartVCDidAppear;
- (void)allPartVCWillDisappear;
- (void)allPartVCDidDisappear;

@end
