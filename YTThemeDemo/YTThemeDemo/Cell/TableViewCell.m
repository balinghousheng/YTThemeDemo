//
//  TableViewCell.m
//  DKNightVersion
//
//  Created by Draveness on 5/1/15.
//  Copyright (c) 2015 Draveness. All rights reserved.
//

#import "TableViewCell.h"
#import "DKNightVersion.h"

@interface TableViewCell ()

@property (nonatomic, strong) UIImageView *separatorImageView;

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        
        self.label = [UILabel new];
        self.label.numberOfLines = 0;
        self.label.textColor = [UIColor darkGrayColor];
        self.label.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.label];

        self.button = [UIButton new];
        self.button.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.button setTitleColor:[UIColor colorWithRed:0.478 green:0.651 blue:0.988 alpha:1.0] forState:UIControlStateNormal];
        [self.contentView addSubview:self.button];
        self.button.layer.borderWidth = 0.5;
        self.button.layer.borderColor = [UIColor redColor].CGColor;

        self.separatorImageView = [UIImageView new];
        [self.contentView addSubview:self.separatorImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(20, 10, 270, 80);
    self.label.text = @"DKNightVersion is a light weight framework adding night mode to your iOS app.";
    
    //self.button.frame = CGRectMake(self.contentView.frame.size.width - 70.0, (self.contentView.frame.size.height - 60.0) / 2, 60.0, 60.0);
    //[self.button dk_setImage:[DKImage pickerWithImageName:@"Head_Icon"] forState:UIControlStateNormal];
    //[self.button dk_setBackgroundImage:[DKImage pickerWithImageName:@"Head_Icon"] forState:UIControlStateNormal];
    self.button.frame = CGRectMake(self.contentView.frame.size.width - 110.0, (self.contentView.frame.size.height - 60.0) / 2, 100.0, 60.0);
    [self.button dk_setBackgroundImage:[DKImage pickerWithImageName:@"Button_Bg"] forState:UIControlStateNormal backgroundImageResizable:YES];
    
    self.separatorImageView.frame = CGRectMake(0.0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
    // 几种方式设置
    self.separatorImageView.dk_imagePicker = [DKImage pickerWithImageName:@"Common/Separator_Shadow"];
    //self.separatorImageView.dk_imagePicker = DKImagePickerWithNames(@"Skin/Day/Common/Separator_Shadow", @"Skin/Night/Common/Separator_Shadow");
    //self.separatorImageView.dk_imagePicker = [DKImage pickerWithNames:@[@"Skin/Day/Common/Separator_Shadow", @"Skin/Night/Common/Separator_Shadow"]];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(HIGHLIGHTED);
    } else {
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    }
}

@end
