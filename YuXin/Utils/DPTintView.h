//
//  DPTintView.h
//  YuXin
//
//  Created by Dai Pei on 2016/8/18.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPTintViewDelegate;

@interface DPTintView : UIView

@property (nonatomic, weak) id<DPTintViewDelegate> delegate;
@property (nonatomic, strong) NSString *guide;

- (instancetype)initWithGuide:(NSString *)guide;

@end

@protocol DPTintViewDelegate <NSObject>

@optional
- (void)tintViewDidClick;

@end
