//
//  CC98FaceIconMultiplePageView.h
//  CC98Lite
//
//  Created by S on 15/6/14.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98FaceIconPageViewDelegate.h"

@interface CC98FaceIconMultiplePageView : UIView <UIScrollViewDelegate, CC98FaceIconPageViewDelegate>

@property (assign, nonatomic) id<CC98FaceIconPageViewDelegate> delegate;

- (void)setupUserInterface;

@end
