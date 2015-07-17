//
//  UILabel+CC98Style.h
//  CC98Lite
//
//  Created by S on 15/6/5.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CC98Style)

- (void)setLabelText:(NSString *)content
           withStyle:(NSString *)style
            andPoint:(CGFloat)pointSize
            andColor:(UIColor *)color;

@end
