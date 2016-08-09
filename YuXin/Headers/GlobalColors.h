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

#define DPBackgroundColor                       UIColorFromRGBA(248,248,248,1.0f)
#define DPTableCellBGColor                      UIColorFromRGBA(255,255,255,1.0f)

#define DPImageBorderColor                      UIColorFromRGBA(239,238,244,0.5f)

#define DPLoginBackgroundColor                  UIColorFromRGB(255,214,0)
#define DPLoginTextFieldBGColor                 UIColorFromRGB(240,240,240)
#define DPLoginButtonColor                      UIColorFromRGB(233,39,84)

#define DPFirstLevelTitleColor                  [UIColor blackColor]
#define DPSecondLevelTitleColor                 [UIColor grayColor]
#define DPBodyTextColor                         [UIColor blackColor]

#define DPTextColorBlack                        UIColorFromRGB(36,36,36)
#define DPTextColorRed                          [UIColor redColor]
#define DPTextColorGreen                        [UIColor greenColor]
#define DPTextColorYellow                       [UIColor yellowColor]
#define DPTextColorDarkBlue                     [UIColor blueColor]
#define DPTextColorPink                         [UIColor magentaColor]
#define DPTextColorLightBlue                    [UIColor cyanColor]
#define DPTextColorWhite                        [UIColor lightGrayColor]

#define DPSeparationLineColor                   UIColorFromRGBA(216,216,216,1.0f)

#define DPTabBarTopLineColor                    UIColorFromRGBA(175,175,175,1.0f)

#define DPArticleDeleteButtonColor              UIColorFromRGB(90,90,90)

#endif /* GlobalColors_h */
