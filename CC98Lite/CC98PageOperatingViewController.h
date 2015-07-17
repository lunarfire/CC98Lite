//
//  CC98PageOperatingViewController.h
//  CC98Lite
//
//  Created by S on 15/6/11.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98PageOperatingVCDelegate.h"

@interface CC98PageOperatingViewController : UIViewController

@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) NSInteger currentPageNum;
@property (weak, nonatomic) id<CC98PageOperatingVCDelegate> delegate;

@end
