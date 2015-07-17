//
//  CC98AccountListTableViewCell.m
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98AccountListTableViewCell.h"

@implementation CC98AccountListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, self.textLabel.center.y-15, 35, 35);
    
    CGRect newFrame = self.textLabel.frame;
    newFrame.origin.x = 80;
    self.textLabel.frame = newFrame;
}

@end
