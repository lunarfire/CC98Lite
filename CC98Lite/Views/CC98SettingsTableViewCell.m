//
//  CC98SettingsTableViewCell.m
//  CC98Lite
//
//  Created by S on 15/6/29.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98SettingsTableViewCell.h"
#import "CC98GlobalSettings.h"

@interface CC98SettingsTableViewCell ()

@property (weak, nonatomic) IBOutlet UISwitch *imageDisplaySwitch;

@end

@implementation CC98SettingsTableViewCell

- (IBAction)switchForDisplayImage:(UISwitch *)sender {
    [CC98GlobalSettings setEnableAllImagesDisplay:self.imageDisplaySwitch.isOn];
}

- (void)awakeFromNib {
    self.imageDisplaySwitch.on = [CC98GlobalSettings enableAllImagesDisplay]; // 如果KEY不存在，默认返回NO，与设计相符
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
