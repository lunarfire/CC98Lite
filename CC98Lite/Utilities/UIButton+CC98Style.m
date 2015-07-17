//
//  UIButton+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/11.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "UIButton+CC98Style.h"
#import "UIColor+CC98Style.h"

@implementation UIButton (CC98Style)

- (void)configCC98Style {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:3.0f];
    [self.layer setBorderWidth:0.8f];
    [self.layer setBorderColor:[UIColor lightBlueColor].CGColor];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor lightBlueColor]];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    static const CGFloat SCALE_FACTOR = 0.8;
    self.bounds = CGRectMake(0, 0, screenWidth*SCALE_FACTOR/3, 33);
}

@end
