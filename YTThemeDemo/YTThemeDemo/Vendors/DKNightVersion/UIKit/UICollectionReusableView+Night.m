//
//  UICollectionReusableView+Night.m
//  YTThemeDemo
//
//  Created by yitudev on 16/12/26.
//  Copyright © 2016年 xx公司. All rights reserved.
//

#import "UICollectionReusableView+Night.h"
#import <objc/runtime.h>

@interface UICollectionReusableView ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UICollectionReusableView (Night)

- (DKColorPicker)dk_backgroundColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_backgroundColorPicker));
}

- (void)dk_setBackgroundColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_backgroundColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.backgroundColor = picker(self.dk_manager.themeVersion);
    [self.pickers setValue:[picker copy] forKey:@"setBackgroundColor:"];
}

@end
