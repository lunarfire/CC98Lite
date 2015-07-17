//
//  CC98PartitionListDataSource.h
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CC98BlockListDataSource.h"

@class CC98CommonPartition;

@interface CC98PartitionListDataSource : NSObject <UITableViewDataSource, CC98BlockListDataSource>

- (CC98CommonPartition *)partitionForIndexPath:(NSIndexPath *)indexPath;

@end
