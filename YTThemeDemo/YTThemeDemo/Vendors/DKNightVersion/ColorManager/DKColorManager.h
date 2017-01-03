//
//  DKColorManager.h
//  YTThemeDemo
//
//  Created by yitudev on 16/12/23.
//  Copyright © 2016年 xx公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKNightVersionManager.h"

#define DKColorPickerWithKey(key) [[DKColorManager sharedColorTable] pickerWithKey:@#key]

@interface DKColorManager : NSObject

@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong, readonly) NSArray<DKThemeVersion *> *themes;

/**
 单例

 @return <#return value description#>
 */
+ (instancetype)sharedColorTable;

/**
 加载读取色值表
 */
- (void)reloadColorTable;

/**
 根据key获取颜色

 @param key key
 @return 颜色
 */
- (DKColorPicker)pickerWithKey:(NSString *)key;

@end
