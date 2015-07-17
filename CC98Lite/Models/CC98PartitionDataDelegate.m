//
//  CC98PartitionDataDelegate.m
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98PartitionDataDelegate.h"
#import "CC98CommonPartition.h"

@implementation CC98PartitionDataDelegate

- (NSString *)name {
    return self.partition.name;
}

- (NSString *)info {
    return [NSString stringWithFormat:@"版面数: %ld", (long)(self.partition.numberOfBoards)];
}

- (UIImage *)icon {
    return [[self.partition class] icon];
}

@end
