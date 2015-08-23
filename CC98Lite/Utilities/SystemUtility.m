//
//  SystemUtility.m
//  CC98Lite
//
//  Created by S on 15/8/23.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "SystemUtility.h"

@implementation SystemUtility

static const CGFloat DURATION = 0.7f;

#pragma CATransition动画实现
+ (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = DURATION;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end
