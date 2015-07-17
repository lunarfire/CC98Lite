//
//  CC98BoardDataDelegate.m
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BoardDataDelegate.h"
#import "CC98Board.h"

@implementation CC98BoardDataDelegate

- (NSString *)name {
    return self.board.name;
}

- (NSString *)info {
    return [NSString stringWithFormat:@"今日帖数: %ld", (long)(self.board.numberOfPostsToday)];
}

- (UIImage *)icon {
    return [[self.board class] icon];
}

@end
