//
//  YTImageUtils.m
//  YTThemeDemo
//
//  Created by yitudev on 16/12/27.
//  Copyright © 2016年 xx公司. All rights reserved.
//

#import "YTImageUtils.h"

@implementation YTImageUtils

/**
 *  单例
 *
 *  @return <#return value description#>
 */
+ (instancetype)shareInstance {
    static YTImageUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/**
 *  初始化
 *
 *  @return <#return value description#>
 */
- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma makr - Color
/**
 *  Color 创建图片
 *
 *  @param color <#color description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
}

#pragma mark - 方法
/**
 *  拉伸图片
 *
 *  @param image 图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)resizableImage:(UIImage *)image {
    return image = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0];
}

/**
 *   获取指定图径的Gif图片
 *
 *  @param path 路径与图片名称
 *
 *  @return <#return value description#>
 */
- (NSData *)getGifImageWithPath:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
    NSString *imagePath = [resourcePath stringByAppendingPathComponent:path];
    imagePath = [NSString stringWithFormat:@"%@@2x.gif", imagePath];
    
    // NSLog(@"getGifImageWithPath: %@", imagePath);
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    return data;
}

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name {
    return [self getImageWithNameByPath:name resizable:NO];
}

/**
 *  获取指定图径的图片（缓存）
 *
 *  @param name 路径与图片名称
 *
 *  @return <#return value description#>
 */
- (UIImage *)getCacheImageWithNameByPath:(NSString *)name {
    return [self getCacheImageWithNameByPath:name resizable:NO];
}

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable {
    if (name.length == 0) {
        return nil;
    }
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
    NSString *imagePath;
    if ([name rangeOfString:resourcePath].location != NSNotFound) {
        imagePath = name;
    } else {
        imagePath = [resourcePath stringByAppendingPathComponent:name];
    }
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.000000) {
        imagePath = [NSString stringWithFormat:@"%@@2x.png", imagePath];
    }
    
    // NSLog(@"getImageWithNameByPath: %@", imagePath);
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (resizable) {
        image = [self resizableImage:image];
    }
    
    return image;
}

/**
 *  获取指定图径的图片（缓存）
 *
 *  @param name 路径与图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getCacheImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable {
    if (name.length == 0) {
        return nil;
    }
    
    // NSLog(@"getCacheImageWithNameByPath: %@", name);
    UIImage *image = [UIImage imageNamed:name];
    if (resizable) {
        image = [self resizableImage:image];
    }
    
    return image;
}

/**
 *  获取指定图径的图片
 *
 *  @param name   路径与图片名称
 *  @param insets <#insets description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets {
    if (name.length == 0) {
        return nil;
    }
    
    UIImage *image = [self getImageWithNameByPath:name resizable:NO];
    image = [image resizableImageWithCapInsets:insets];
    
    return image;
}

/**
 *  获取指定图径的图片（缓存）
 *
 *  @param name   路径与图片名称
 *  @param insets UIEdgeInsets
 *
 *  @return <#return value description#>
 */
- (UIImage *)getCacheImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets {
    if (name.length == 0) {
        return nil;
    }
    
    UIImage *image = [self getCacheImageWithNameByPath:name resizable:NO];
    image = [image resizableImageWithCapInsets:insets];
    
    return image;
}

@end
