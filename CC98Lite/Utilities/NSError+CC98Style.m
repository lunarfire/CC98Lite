//
//  NSError+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "NSError+CC98Style.h"

@implementation NSError (CC98Style)

+ (NSString *)cc98ErrorDomain {
    return @"MyCC98";
}

+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description {
    return [NSError errorWithDomain:[NSError cc98ErrorDomain]
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey:description}];
}

@end
