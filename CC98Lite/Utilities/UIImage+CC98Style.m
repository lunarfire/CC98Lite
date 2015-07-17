//
//  UIImage+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/28.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "UIImage+CC98Style.h"

@implementation UIImage (CC98Style)

- (UIImage *)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)imageScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    if (self.size.width<=width && self.size.height<=height) {
        return self;
    }
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = oldWidth > oldHeight ? width/oldWidth : height/oldHeight;
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return [self imageScaledToSize:newSize];
}

@end
