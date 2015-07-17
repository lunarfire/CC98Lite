//
//  CC98FaceIconPageView.h
//  CC98Lite
//
//  Created by S on 15/6/14.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98FaceIconPageViewDelegate.h"

@interface CC98FaceIconPageView : UIView

@property (weak, nonatomic) id<CC98FaceIconPageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame forPageNum:(NSInteger)pageNum;

+ (NSInteger)faceIconNumberPerRow:(CGRect)viewFrame;
+ (NSInteger)faceIconRowNumber:(CGRect)viewFrame;
+ (NSInteger)faceIconNumberPerPage:(CGRect)viewFrame;

@end
