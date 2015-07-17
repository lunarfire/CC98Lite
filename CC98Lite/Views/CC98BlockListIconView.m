//
//  CC98BlockListIconView.m
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BlockListIconView.h"
#import "UIColor+CC98Style.h"

@interface CC98BlockListIconView ()

@end


@implementation CC98BlockListIconView

#pragma mark - Initialization

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
    _text = nil;
    _image = image;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    _image = nil;
    _text = text;
    [self setNeedsDisplay];
}

- (void)setFilledColor:(UIColor *)filledColor {
    _filledColor = filledColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    static const CGFloat CORNER_FACTOR = 1.0f/7.0f;
    
    CGFloat cornerRadius = self.bounds.size.width*CORNER_FACTOR;
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:cornerRadius];
    [roundedRect addClip];
    
    if (self.image) {
        [self.filledColor setFill];
        [roundedRect fill];
        
        // [[UIColor goldenColor] setStroke];
        // [roundedRect stroke];
        
        [self.image drawInRect:self.bounds];
    } else if (self.text) {
        [[UIColor redColor] setStroke];
        [roundedRect stroke];
        
        UIFont *textFont = [UIFont fontWithName:@"ArialUnicodeMS" size:10.0f];
        NSDictionary *attributes = @{NSFontAttributeName:textFont,
                                     NSForegroundColorAttributeName:[UIColor redColor]};
        NSAttributedString *colorfulText = [[NSAttributedString alloc] initWithString:self.text
                                                                         attributes:attributes];
        UIEdgeInsets edges = UIEdgeInsetsMake(-1, 2.5, 1.5, 0);
        CGRect textRect = UIEdgeInsetsInsetRect(self.bounds, edges);
        
        [colorfulText drawInRect:textRect];
    }
}


@end
