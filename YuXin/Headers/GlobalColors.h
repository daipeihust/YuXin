//
//  GlobalColors.h
//  YuXin
//
//  Created by Dai Pei on 16/7/15.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#ifndef GlobalColors_h
#define GlobalColors_h

#define UIColorFromRGBA(r,g,b,a)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)                   UIColorFromRGBA(r,g,b,1.0)

#define DPBackgroundColor                       [UIColor whiteColor]
#define DPFirstLevelTitleColor                  [UIColor blackColor]
#define DPSecondLevelTitleColor                 [UIColor grayColor]
#define DPBodyTextColor                         [UIColor blackColor]

#define DPTextColorBlack                        [UIColor blackColor]
#define DPTextColorRed                          [UIColor redColor]
#define DPTextColorGreen                        [UIColor greenColor]
#define DPTextColorYellow                       [UIColor yellowColor]
#define DPTextColorDarkBlue                     [UIColor blueColor]
#define DPTextColorPink                         [UIColor magentaColor]
#define DPTextColorLightBlue                    [UIColor cyanColor]
#define DPTextColorWhite                        [UIColor lightGrayColor]


#endif /* GlobalColors_h */
