//
//  CC98PartitionDataDelegate.h
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98BlockDataDelegate.h"

@class CC98CommonPartition;

@interface CC98PartitionDataDelegate : NSObject <CC98BlockDataDelegate>

@property (strong, nonatomic) CC98CommonPartition *partition;

@end
