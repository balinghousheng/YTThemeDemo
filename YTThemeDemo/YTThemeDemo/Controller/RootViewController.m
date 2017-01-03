//
//  RootViewController.m
//  DKNightVerision
//
//  Created by Draveness on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "RootViewController.h"
#import "SuccViewController.h"
#import "PresentingViewController.h"
#import "DKNightVersion.h"
#import "TableViewCell.h"
#import "UITableViewCell+Night.h"

//@pickerify(TableViewCell, cellTintColor)
// 上面这个宏定义相当于下面的代码：一个UITableViewCell类别

// .h
//@interface UITableViewCell (Night)
//
//@property (nonatomic, copy, setter = dk_setCellTintColorPicker:) DKColorPicker dk_cellTintColorPicker;
//
//@end

// .m
//@interface UITableViewCell ()
//
//@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;
//
//@end
//
//@implementation UITableViewCell (Night)
//
//- (DKColorPicker)dk_cellTintColorPicker {
//    return objc_getAssociatedObject(self, @selector(dk_cellTintColorPicker));
//}
//
//- (void)dk_setCellTintColorPicker:(DKColorPicker)picker {
//    objc_setAssociatedObject(self, @selector(dk_cellTintColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    self.tintColor = picker(self.dk_manager.themeVersion);
//    [self.pickers setValue:[picker copy] forKey:@"setTintColor:"];
//}
//
//@end

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
    navigationLabel.text = @"皮肤切换";
    navigationLabel.textAlignment = NSTextAlignmentCenter;
    navigationLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.navigationItem.titleView = navigationLabel;
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    self.navigationItem.leftBarButtonItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Present" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
    self.navigationItem.leftBarButtonItem = item;

    UIBarButtonItem *normalItem = [[UIBarButtonItem alloc] initWithTitle:@"白天" style:UIBarButtonItemStylePlain target:self action:@selector(normal)];
    normalItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    UIBarButtonItem *nightItem = [[UIBarButtonItem alloc] initWithTitle:@"夜间" style:UIBarButtonItemStylePlain target:self action:@selector(night)];
    nightItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    self.navigationItem.rightBarButtonItems = @[normalItem, nightItem];

    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
    //self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    //self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
}

#pragma mark - 
- (void)night {
    self.dk_manager.themeVersion = DKThemeVersionNight;
}

- (void)normal {
    self.dk_manager.themeVersion = DKThemeVersionNormal;
}

- (void)change {
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        [self.dk_manager dawnComing];
    } else {
        [self.dk_manager nightFalling];
    }
}

#pragma mark -
- (void)push {
    [self.navigationController pushViewController:[[SuccViewController alloc] init] animated:YES];
}

- (void)present {
    [self presentViewController:[[PresentingViewController alloc] init] animated:YES completion:nil];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //cell.dk_cellTintColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434);
    //cell.dk_cellTintColorPicker = DKColorPickerWithKey(BG);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self push];
}

@end
