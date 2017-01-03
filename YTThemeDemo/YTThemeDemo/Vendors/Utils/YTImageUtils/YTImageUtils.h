//
//  YTImageUtils.h
//  YTThemeDemo
//
//  Created by yitudev on 16/12/27.
//  Copyright © 2016年 xx公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTImageUtils : NSObject

/**
 *  单例
 *
 *  @return <#return value description#>
 */
+ (instancetype)shareInstance;

#pragma mark - Color
/**
 *  Color 创建图片
 *
 *  @param color <#color description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 方法
/**
 *  拉伸图片
 *
 *  @param image 图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)resizableImage:(UIImage *)image;

/**
 *   获取指定图径的Gif图片
 *
 *  @param path 路径与图片名称
 *
 *  @return <#return value description#>
 */
- (NSData *)getGifImageWithPath:(NSString *)path;

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name;

/**
 *  获取指定图径的图片（缓存）
 *
 *  @param name 路径与图片名称
 *
 *  @return <#return value description#>
 */
- (UIImage *)getCacheImageWithNameByPath:(NSString *)name;

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable;

/**
 *  获取指定图径的图片（缓存）
 *
 *  @param name 路径与图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getCacheImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable;

/**
 *  获取指定图径的图片
 *
 *  @param name   路径与图片名称
 *  @param insets UIEdgeInsets
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets;

/**
 *  获取指定图径的图片（缓存）
 *
 *  @param name   路径与图片名称
 *  @param insets UIEdgeInsets
 *
 *  @return <#return value description#>
 */
- (UIImage *)getCacheImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets;

@end
