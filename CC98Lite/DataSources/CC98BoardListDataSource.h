//
//  CC98BoardListDataSource.h
//  CC98Lite
//
//  Created by S on 15/6/1.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CC98BlockListDataSource.h"

@class CC98Partition;
@class CC98Board;

@interface CC98BoardListDataSource : NSObject <UITableViewDataSource, CC98BlockListDataSource>

@property (strong, nonatomic) CC98Partition *partition;

@end
