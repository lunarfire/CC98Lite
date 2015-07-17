//
//  CC98CommonPartition.h
//  CC98Lite
//
//  Created by S on 15/6/1.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98Partition.h"

@class UIImage;


@interface CC98CommonPartition : CC98Partition

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSArray *moderators;
@property (assign, nonatomic) NSInteger numberOfBoards;
@property (assign, nonatomic) NSInteger numberOfPostsToday;
@property (assign, nonatomic) NSInteger numberOfAllPosts;

+ (UIImage *)icon;

@end
