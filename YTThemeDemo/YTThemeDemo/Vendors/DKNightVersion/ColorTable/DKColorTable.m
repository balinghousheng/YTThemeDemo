//
//  DKColorTable.m
//  DKNightVersion
//
//  Created by Draveness on 15/12/11.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "DKColorTable.h"

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

@interface DKColorTable ()
/// 色值表
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, UIColor *> *> *table;
/// 主题类型
@property (nonatomic, strong, readwrite) NSArray<DKThemeVersion *> *themes;
@end

@implementation DKColorTable

UIColor *DKColorFromRGB(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0];
}

UIColor *DKColorFromRGBA(NSUInteger hex) {
    return [UIColor colorWithRed:((CGFloat)((hex >> 24) & 0xFF)/255.0) green:((CGFloat)((hex >> 16) & 0xFF)/255.0) blue:((CGFloat)((hex >> 8) & 0xFF)/255.0) alpha:((CGFloat)(hex & 0xFF)/255.0)];
}

+ (instancetype)sharedColorTable {
    static DKColorTable *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DKColorTable alloc] init];
        sharedInstance.file = @"DKColorTable.txt";
    });
    return sharedInstance;
}

/**
 读取色值文件
 */
- (void)reloadColorTable {
    // Clear previos color table
    self.table = nil;
    self.themes = nil;

    // Load color table file
    NSString *filepath = [[NSBundle mainBundle] pathForResource:self.file.stringByDeletingPathExtension ofType:self.file.pathExtension];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];

    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);

    NSLog(@"DKColorTable:\n%@", fileContents);


    NSMutableArray *tempEntries = [[fileContents componentsSeparatedByString:@"\n"] mutableCopy];
    
    // Fixed whitespace error in txt file, fix https://github.com/Draveness/DKNightVersion/issues/64
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    [tempEntries enumerateObjectsUsingBlock:^(NSString *  _Nonnull entry, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *trimmingEntry = [entry stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [entries addObject:trimmingEntry];
    }];
    [entries filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];

    [entries removeObjectAtIndex:0]; // Remove theme entry

    // 主题类型：NORMAL, NIGHT, RED
    self.themes = [self themesFromContents:fileContents];
    
    // Add entry to color table
    for (NSString *entry in entries) {
        NSArray *colors = [self colorsFromEntry:entry];
        NSString *keys = [self keyFromEntry:entry];
        
        [self addEntryWithKey:keys colors:colors themes:self.themes];
    }
}

/**
 获取主题类型数组
 
 @param content <#content description#>
 @return <#return value description#>
 */
- (NSArray *)themesFromContents:(NSString *)content {
    NSString *rawThemes = [content componentsSeparatedByString:@"\n"].firstObject;
    return [self separateString:rawThemes];
}

/**
 获取一行的色值数组
 
 @param entry <#entry description#>
 @return <#return value description#>
 */
- (NSArray *)colorsFromEntry:(NSString *)entry {
    NSMutableArray *colors = [[self separateString:entry] mutableCopy];
    [colors removeLastObject];
    NSMutableArray *result = [@[] mutableCopy];
    for (NSString *number in colors) {
        [result addObject:[self colorFromString:number]];
    }
    return result;
}

/**
 获取一行的色值key
 
 @param entry <#entry description#>
 @return <#return value description#>
 */
- (NSString *)keyFromEntry:(NSString *)entry {
    return [self separateString:entry].lastObject;
}

/**
 将色值、key以键值对形式存在字典中<NSString *, NSMutableDictionary<NSString *, UIColor *> *>
 self.table = {
 BG =     {
 NIGHT = "UIExtendedSRGBColorSpace 0.203922 0.203922 0.203922 1";
 NORMAL = "UIExtendedSRGBColorSpace 1 1 1 1";
 RED = "UIExtendedSRGBColorSpace 0.980392 0.980392 0.980392 1";
 };
 SEP =     {
 NIGHT = "UIExtendedSRGBColorSpace 0.192157 0.192157 0.192157 1";
 NORMAL = "UIExtendedSRGBColorSpace 0.666667 0.666667 0.666667 1";
 RED = "UIExtendedSRGBColorSpace 0.666667 0.666667 0.666667 1";
 };
 TINT =     {
 NIGHT = "UIExtendedSRGBColorSpace 1 1 1 1";
 NORMAL = "UIExtendedSRGBColorSpace 0 0 1 1";
 RED = "UIExtendedSRGBColorSpace 0.980392 0 0 1";
 };
 }
 
 @param key 对应的key
 @param colors 色值数组
 @param themes 主题数组
 */
- (void)addEntryWithKey:(NSString *)key colors:(NSArray *)colors themes:(NSArray *)themes {
    NSParameterAssert(themes.count == colors.count);

    __block NSMutableDictionary *themeToColorDictionary = [@{} mutableCopy];

    [themes enumerateObjectsUsingBlock:^(NSString * _Nonnull theme, NSUInteger idx, BOOL * _Nonnull stop) {
        [themeToColorDictionary setValue:colors[idx] forKey:theme];
    }];

    [self.table setValue:themeToColorDictionary forKey:key];
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
        return DKColorFromRGBA(hex);
    }

    return DKColorFromRGB(hex);
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
