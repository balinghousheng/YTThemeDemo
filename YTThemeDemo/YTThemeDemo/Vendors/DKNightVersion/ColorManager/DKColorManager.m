//
//  DKColorManager.m
//  YTThemeDemo
//
//  Created by yitudev on 16/12/23.
//  Copyright © 2016年 xx公司. All rights reserved.
//

#import "DKColorManager.h"

@interface NSString (Trimming)

@end

@implementation NSString (Trimming)

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end

@interface DKColorManager ()
/// 色值表
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, UIColor *> *> *table;
/// 主题类型
@property (nonatomic, strong, readwrite) NSArray<DKThemeVersion *> *themes;
/// 颜色名称
@property (nonatomic, strong, readwrite) NSArray *colorNames;
@end

@implementation DKColorManager

UIColor *DKColorFromRGB2(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0];
}

UIColor *DKColorFromRGBA2(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 24) & 0xFF)/255.0) green:((CGFloat)((hex >> 16) & 0xFF)/255.0) blue:((CGFloat)((hex >> 8) & 0xFF)/255.0) alpha:((CGFloat)(hex & 0xFF)/255.0)];
}

+ (instancetype)sharedColorTable {
    static DKColorManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DKColorManager alloc] init];
        sharedInstance.file = @"YTThemeColor.plist";
    });
    return sharedInstance;
}

/**
 读取色值文件
 */
- (void)reloadColorTable {
    self.table = nil;
    self.themes = nil;
    self.colorNames = nil;
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:self.file.stringByDeletingPathExtension ofType:self.file.pathExtension];
    NSMutableDictionary *colorDic = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    
    self.colorNames = [colorDic allKeys];
    self.themes = [[colorDic objectForKey:self.colorNames[0]] allKeys];
    [colorDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:obj];
        NSString *normal = [tempDict objectForKey:self.themes[0]];
        NSString *night = [tempDict objectForKey:self.themes[1]];
        
        [obj setObject:[ self getColorWithNameByTheme:normal] forKey:self.themes[0]];
        [obj setObject:[ self getColorWithNameByTheme:night] forKey:self.themes[1]];
    }];
    
    self.table = colorDic;
}

/**
 根据RGB指生成颜色

 @param name RGB颜色字符串，eg：255, 255, 255
 @return UIColor
 */
- (UIColor *)getColorWithNameByTheme:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }
    
    NSArray *rgbs = [name componentsSeparatedByString:@","];
    if (rgbs.count < 3) {
        return nil;
    }
    
    CGFloat r = [rgbs[0] floatValue];
    CGFloat g = [rgbs[1] floatValue];
    CGFloat b = [rgbs[2] floatValue];
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

/**
 根据key及主题类型获取对应的颜色
 
 @param key <#key description#>
 @return <#return value description#>
 */
- (DKColorPicker)pickerWithKey:(NSString *)key {
    NSParameterAssert(key);
    
    NSDictionary *themeToColorDictionary = [self.table valueForKey:key];
    DKColorPicker picker = ^(DKThemeVersion *themeVersion) {
        return [themeToColorDictionary valueForKey:themeVersion];
    };
    return picker;
    
}

#pragma mark - Getter/Setter

- (NSMutableDictionary *)table {
    if (!_table) {
        _table = [[NSMutableDictionary alloc] init];
    }
    return _table;
}

- (void)setFile:(NSString *)file {
    _file = file;
    [self reloadColorTable];
}

#pragma mark - Helper

- (UIColor*)colorFromString:(NSString*)hexStr {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSUInteger hex = [self intFromHexString:hexStr];
    if(hexStr.length > 6) {
        return DKColorFromRGBA2(hex);
    }
    
    return DKColorFromRGB2(hex);
}

- (NSUInteger)intFromHexString:(NSString *)hexStr {
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

/**
 将NORMAL   NIGHT    RED 分成一个字符串数组
 
 @param string <#string description#>
 @return <#return value description#>
 */
- (NSArray *)separateString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
}

@end
