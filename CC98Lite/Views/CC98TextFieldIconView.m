//
//  CC98TextFieldIconView.m
//  CC98Lite
//
//  Created by S on 15/6/4.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98TextFieldIconView.h"
#import "UIColor+CC98Style.h"

@implementation CC98TextFieldIconView

-(void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib {
    [self setup];
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGFloat diameter = self.bounds.size.height;
    UIBezierPath *cycle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, diameter, diameter)];
    [cycle addClip];
    
    [[UIColor lightBlueColor] setFill];
    [cycle fill];
    
    // [[UIColor goldenColor] setStroke];
    // [cycle stroke];
    
    if (self.image) {
        [self.image drawInRect:CGRectMake(0, 0, diameter, diameter)];
    }
}


@end
