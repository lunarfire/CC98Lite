//
//  UIImage+CC98Style.h
//  CC98Lite
//
//  Created by S on 15/6/28.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CC98Style)

- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;

@end
