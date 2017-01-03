//
//  UIImageView+Night.h
//  DKNightVersion
//
//  Created by Draveness on 15/12/10.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKNightVersionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Night)

@property (nullable, nonatomic, copy, setter = dk_setImagePicker:) DKImagePicker dk_imagePicker;
@property (nonatomic, strong, setter = dk_setImageName:) NSString *dk_imageName;

/// 根据图片返回UIImageView实例（图片名在外部设置）
- (instancetype)dk_initWithImagePicker:(DKImagePicker)picker;
/// 根据图片名返回UIImageView实例
- (instancetype)dk_initWithImageName:(NSString *)imageName;
/// 根据图片名返回UIImageView实例，图片可设置是否拉伸
- (instancetype)dk_initWithImageName:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInsets;
/// 根据图片名返回UIImageView实例，图片可设置拉伸范围
- (instancetype)dk_initWithImageName:(NSString *)imageName resizeable:(BOOL)resizeable;

@end

NS_ASSUME_NONNULL_END
