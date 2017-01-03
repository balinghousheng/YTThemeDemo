# YTThemeDemo
runtime实现白天和夜间模式切换，使用plist文件进行色值配置

* 使用**[DKNightVersion](https://github.com/Draveness/DKNightVersion)**进行的修改

1、目录结构：

![tmp40972269.png](http://upload-images.jianshu.io/upload_images/1252567-ea2bb2988592bd7e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Core:核心类（DKColor颜色设置，DKImage图片设置，DKColorTable处理皮肤配置文件，DKNightVersionManager皮肤管理类，NSObject+Night扩展一个DKNightVersionManager）

DeallocBlockExecutor:内存回收(移除通知)相关的回调

CoreAnimation:动画Layer的扩展

Resources:皮肤配置文件

UIKit:皮肤控件的扩展

2、思路

2.1、扩展NSObject通过DKNightVersionManager单例来管理皮肤的切换，设置themeVersion后保存到本地，并通知其它视图更新颜色。

```
- (void)setThemeVersion:(DKThemeVersion *)themeVersion {
    if ([_themeVersion isEqualToString:themeVersion]) {
        // if type does not change, don't execute code below to enhance performance.
        return;
    }
    _themeVersion = themeVersion;

    // Save current theme version to user default
    [[NSUserDefaults standardUserDefaults] setValue:themeVersion forKey:DKNightVersionCurrentThemeVersionKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DKNightVersionThemeChangingNotificaiton
                                                        object:nil];

    if (self.shouldChangeStatusBar) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([themeVersion isEqualToString:DKThemeVersionNight]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
#pragma clang diagnostic pop
    }
}
```

2.2、颜色设置：如TableViewCell的背景颜色通过一个属性`dk_cellTintColorPicker`进行，实质是一个 block，它接收参数 `DKThemeVersion *themeVersion`，但是会返回一个 `UIColor *`；
UIKit扩展中.m文件中的属性`pickers`和`NSObject+Night`中`pickers`是一个东西。

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // 项目中这里是写的一个宏自动生成，效果跟写一个UITableViewCell+Night类别是一样的
    cell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);

    return cell;
}
```

2.3、然后通过属性关联设置UITableView的 `tintColor `；同时，每一个对象还持有一个` pickers` 数组，来存储自己的全部 `DKColorPicker：`。

```
@interface UITableViewCell ()

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
```

2.4、在第一次使用这个属性时，当前对象注册为  `DKNightVersionThemeChangingNotificaiton ` 通知的观察者。 `pickers `属性只有在对象的某个 `DKColorPicker/DKImagePicker `首次被赋值时才会被创建。
在每次收到通知时，都会调用  `night_update ` 方法，将当前主题传入  `DKColorPicker `，并再次执行，并将结果传入对应的属性 ` [self performSelector:sel withObject:result] `。

```
- (NSMutableDictionary<NSString *, DKColorPicker> *)pickers {
    // 第一次进来pickers为空进入if
    NSMutableDictionary<NSString *, DKColorPicker> *pickers = objc_getAssociatedObject(self, @selector(pickers));
    if (!pickers) {
        
        @autoreleasepool {
            // Need to removeObserver in dealloc
            if (objc_getAssociatedObject(self, &DKViewDeallocHelperKey) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                id deallocHelper = [self addDeallocBlock:^{
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                }];
                objc_setAssociatedObject(self, &DKViewDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
        }

        pickers = [[NSMutableDictionary alloc] init];
        // 将局部变量pickers和当前对象的pickers关联
        objc_setAssociatedObject(self, @selector(pickers), pickers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DKNightVersionThemeChangingNotificaiton object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(night_updateColor) name:DKNightVersionThemeChangingNotificaiton object:nil];
    }
    return pickers;
}

- (void)night_updateColor {
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selector);
        id result = picker(self.dk_manager.themeVersion);
        [UIView animateWithDuration:DKNightVersionAnimationDuration
                         animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [self performSelector:sel withObject:result];
#pragma clang diagnostic pop
                         }];
    }];
}
```
