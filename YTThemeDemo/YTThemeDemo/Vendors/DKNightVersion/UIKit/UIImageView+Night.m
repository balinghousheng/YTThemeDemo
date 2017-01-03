//
//  UIImageView+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/10.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "UIImageView+Night.h"
#import "NSObject+Night.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UIImageView (Night)

#pragma mark - 属性关联
- (DKImagePicker)dk_imagePicker {
    return objc_getAssociatedObject(self, @selector(dk_imagePicker));
}

- (void)dk_setImagePicker:(DKImagePicker)picker {
    objc_setAssociatedObject(self, @selector(dk_imagePicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.image = picker(self.dk_manager.themeVersion);
    [self.pickers setValue:[picker copy] forKey:@"setImage:"];
}

- (NSString *)dk_imageName {
    return objc_getAssociatedObject(self, @selector(dk_setImageName:));
}

- (void)dk_setImageName:(NSString *)imageName {
    objc_setAssociatedObject(self, @selector(dk_imageName), imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 实例方法
- (instancetype)dk_initWithImagePicker:(DKImagePicker)picker {
    UIImage *image = picker(self.dk_manager.themeVersion);
    UIImageView *imageView = [self initWithImage:image];
    imageView.dk_imagePicker = [picker copy];
    return imageView;
}

- (instancetype)dk_initWithImageName:(NSString *)imageName {
    return [self dk_initWithImageName:imageName edgeInsets:UIEdgeInsetsZero];
}

- (instancetype)dk_initWithImageName:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInsets {
    self.dk_imageName = imageName;
    return [self dk_initWithImagePicker:[DKImage pickerWithImageName:imageName edgeInsets:edgeInsets]];
}

- (instancetype)dk_initWithImageName:(NSString *)imageName resizeable:(BOOL)resizeable {
    self.dk_imageName = imageName;
    return [self dk_initWithImagePicker:[DKImage pickerWithImageName:imageName resizeable:resizeable]];
}

#pragma mark - 切换皮肤
- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary<NSString *, DKColorPicker> *dictionary = (NSDictionary *)obj;
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:DKNightVersionAnimationDuration
                                 animations:^{
                                     if (!self.dk_imageName && [self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                                         // dk_imageName不存在，则加载的是网络图片
                                         self.alpha = 0.5;
                                     } else {
                                         self.alpha = 1.0;
                                     }
                                     
                                     UIImage *resultImage = ((DKImagePicker)picker)(self.dk_manager.themeVersion);
                                     self.image = resultImage;
                                 }];
            }];
        } else {
            SEL sel = NSSelectorFromString(key);
            DKColorPicker picker = (DKColorPicker)obj;
            UIColor *resultColor = picker(self.dk_manager.themeVersion);
            [UIView animateWithDuration:DKNightVersionAnimationDuration
                             animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                 [self performSelector:sel withObject:resultColor];
#pragma clang diagnostic pop
                             }];
            
        }
    }];
}

@end
