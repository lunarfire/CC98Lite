//
//  CC98Forum.m
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98Forum.h"
#import "CC98Client.h"
#import "GTMNSString+HTML.h"
#import "NSString+CC98Style.h"
#import "CC98RegexRepository.h"
#import "CC98CommonPartition.h"
#import "CC98PersonalPartition.h"

@implementation CC98Forum

@synthesize personalPartition = _personalPartition;


static CC98Forum *sharedCC98Forum = nil;

+ (CC98Forum *)sharedInstance {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            sharedCC98Forum = [[CC98Forum alloc] init];
        });
    }
    return sharedCC98Forum;
}

- (NSString *)address {
    return @"index.asp";
}

- (void)commonPartitionsWithBlock:(void (^)(NSArray *partitions, NSError *error))block {
    
    [[CC98Client sharedInstance] GET:[self address]
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {

        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        NSArray *matches = [content everyMatchRegex:PARTITION_WRAPPER_REGEX];
        NSMutableArray *tempPartitions = [NSMutableArray arrayWithCapacity:matches.count];

        for (NSString *match in matches) {
            CC98CommonPartition *partition = [[CC98CommonPartition alloc] init];
            partition.name = [[match firstMatchRegex:PARTITION_NAME_REGEX] gtm_stringByUnescapingFromHTML];
            partition.numberOfBoards = [[match firstMatchRegex:PARTITION_BOARDS_NUM_REGEX] integerValue];
            partition.identifier = [match firstMatchRegex:PARTITION_ID_REGEX];
            
            if (partition.name != nil) {
                [tempPartitions addObject:partition];
            }
        }
        if (block) { block([NSArray arrayWithArray:tempPartitions], nil); }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];
}

- (CC98PersonalPartition *)personalPartition {
    if (!_personalPartition) {
        _personalPartition = [[CC98PersonalPartition alloc] init];
    }
    return _personalPartition;
}


@end
