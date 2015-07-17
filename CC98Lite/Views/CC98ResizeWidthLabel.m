//
//  CC98ResizeWidthLabel.m
//  CC98Lite
//
//  Created by S on 15/6/6.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98ResizeWidthLabel.h"

@implementation CC98ResizeWidthLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    self.preferredMaxLayoutWidth = self.bounds.size.width;
    [self setNeedsUpdateConstraints];
}

@end
