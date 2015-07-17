//
//  CC98Forum.h
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class CC98PersonalPartition;


@interface CC98Forum : NSObject

@property (weak, readonly) UIImage *logo;
@property (nonatomic, readonly) CC98PersonalPartition *personalPartition;

+ (CC98Forum *)sharedInstance;
- (void)commonPartitionsWithBlock:(void (^)(NSArray *partitions, NSError *error))block;

@end
