//
//  CC98BarButtonItem.h
//  CC98Lite
//
//  Created by S on 15/6/10.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98BarButtonItemDelegate.h"


@interface CC98BarButtonItem : UIBarButtonItem

@property (nonatomic, weak) id<CC98BarButtonItemDelegate> delegate;

@end
