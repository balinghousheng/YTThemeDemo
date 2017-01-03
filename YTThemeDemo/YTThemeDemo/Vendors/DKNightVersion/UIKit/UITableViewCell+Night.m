//
//  UITableViewCell+Night.m
//  Example
//
//  Created by yitudev on 16/11/8.
//  Copyright © 2016年 xx公司. All rights reserved.
//

#import "UITableViewCell+Night.h"
#import <objc/runtime.h>

@interface UITableViewCell ()

/// 和NSObject+Night中pickers是一个东西
@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UITableViewCell (Night)

- (DKColorPicker)dk_cellTintColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_cellTintColorPicker));
}

- (void)dk_setCellTintColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_cellTintColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.tintColor = picker(self.dk_manager.themeVersion);
    [self.pickers setValue:[picker copy] forKey:@"setTintColor:"];
}

@end
