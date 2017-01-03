//
//  SuccViewController.m
//  DKNightVersion
//
//  Created by Draveness on 4/28/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "SuccViewController.h"
#import "DKNightVersion.h"

@interface SuccViewController ()

@end

@implementation SuccViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.navigationController.navigationBar.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    
    UIBarButtonItem *normalItem = [[UIBarButtonItem alloc] initWithTitle:@"白天" style:UIBarButtonItemStylePlain target:self action:@selector(normal)];
    normalItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    UIBarButtonItem *nightItem = [[UIBarButtonItem alloc] initWithTitle:@"夜间" style:UIBarButtonItemStylePlain target:self action:@selector(night)];
    nightItem.dk_tintColorPicker = DKColorPickerWithKey(TINT);
    self.navigationItem.rightBarButtonItems = @[normalItem, nightItem];

    UITextField *textField = [[UITextField alloc] init];
    textField.frame = self.view.frame;
    textField.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [self.view addSubview:textField];
    
//    UIImageView *imageView = [[UIImageView alloc] dk_initWithImagePicker:[DKImage pickerWithImageName:@"Button_Bg" edgeInsets:UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0)]];
//    imageView.frame = CGRectMake(50.0, 80.0, 200.0, 150.0);
//    [self.view addSubview:imageView];
    UIImageView *imageView = [[UIImageView alloc] dk_initWithImageName:@"Button_Bg" edgeInsets:UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0)];
    imageView.frame = CGRectMake(10.0, 80.0, 200.0, 150.0);
    [self.view addSubview:imageView];
}

#pragma mark -
- (void)night {
    self.dk_manager.themeVersion = DKThemeVersionNight;
}

- (void)normal {
    self.dk_manager.themeVersion = DKThemeVersionNormal;
}

@end
