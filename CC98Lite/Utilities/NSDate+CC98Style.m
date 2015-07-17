//
//  NSDate+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/5.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "NSDate+CC98Style.h"

@implementation NSDate (CC98Style)

- (NSString *)toString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [formatter stringFromDate:self];
}

@end
