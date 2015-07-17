//
//  UILabel+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/5.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "UILabel+CC98Style.h"
#import "NSString+CC98Style.h"

@implementation UILabel (CC98Style)

- (void)setLabelText:(NSString *)content
           withStyle:(NSString *)style
            andPoint:(CGFloat)pointSize
            andColor:(UIColor *)color {
    
    UIFont *labelFont = [UIFont preferredFontForTextStyle:style];
    labelFont = [labelFont fontWithSize:pointSize];

    NSDictionary *textAttributes = @{NSFontAttributeName:labelFont,
                                     NSForegroundColorAttributeName:color};
    self.attributedText = [[NSAttributedString alloc] initWithString:[NSString showStringSafely:content]
                                                          attributes:textAttributes];
}

@end
