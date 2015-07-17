//
//  CC98Partition.h
//  CC98Lite
//
//  Created by S on 15/5/25.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98Partition : NSObject

@property (weak, readonly) NSString *address;
@property (strong, nonatomic) NSString *name;

- (void)boardsOrPartitionsWithBlock:(void (^)(NSDictionary *boardsOrPartitions, NSError *error))block;

@end;
