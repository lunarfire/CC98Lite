//
//  UITableViewCell+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/5.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "UITableViewCell+CC98Style.h"

@implementation UITableViewCell (CC98Style)

- (CGFloat)calculateHeightOfCellWithTableViewFrame:(CGRect)frame {
    self.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(self.bounds));
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

@end
