//
//  UIButton+Night.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/9.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Night.h"

@interface UIButton (Night)

/// 设置按钮文字在不同状态下的颜色
- (void)dk_setTitleColorPicker:(DKColorPicker)picker forState:(UIControlState)state;
/// 设置按钮背景在不同状态下的图片
- (void)dk_setBackgroundImage:(DKImagePicker)picker forState:(UIControlState)state;
/// 设置按钮背景在不同状态下的图片,图片可被拉伸
- (void)dk_setBackgroundImage:(DKImagePicker)picker forState:(UIControlState)state backgroundImageResizable:(BOOL)backgroundImageResizable;
/// 设置按钮在不同状态下的icon
- (void)dk_setImage:(DKImagePicker)picker forState:(UIControlState)state;

@end
