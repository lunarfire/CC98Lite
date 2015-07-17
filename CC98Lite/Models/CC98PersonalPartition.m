//
//  CC98PersonalPartition.m
//  CC98Lite
//
//  Created by S on 15/6/1.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98PersonalPartition.h"
#import "CC98Board.h"
#import "CC98Client.h"
#import "GTMNSString+HTML.h"
#import "NSString+CC98Style.h"
#import "CC98RegexRepository.h"

@implementation CC98PersonalPartition

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"个人定制区";
    }
    return self;
}

- (NSString *)address {
    return @"index.asp";
}

- (void)boardsOrPartitionsWithBlock:(void (^)(NSDictionary *boardsOrPartitions, NSError *error))block {
    
    [[CC98Client sharedInstance] GET:self.address
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        NSArray *matches = [content everyMatchRegex:BOARD_WRAPPER_REGEX];
        NSMutableDictionary *tempBoards = [NSMutableDictionary dictionaryWithCapacity:matches.count];

        NSInteger index = 0;
        for (NSString *match in matches) {
            CC98Board *board = [[CC98Board alloc] init];
            board.name = [[match firstMatchRegex:BOARD_NAME_REGEX] gtm_stringByUnescapingFromHTML];
            board.numberOfPostsToday = [[match firstMatchRegex:BOARD_POSTS_NUM_REGEX] integerValue];
            board.identifier = [match firstMatchRegex:BOARD_ID_REGEX];
            
            NSString *topicNumRaw = [match firstMatchRegex:BOARD_TOPICS_NUM_REGEX_RAW];
            NSString *topicNumber = [[topicNumRaw firstMatchRegex:BOARD_TOPICS_NUM_REGEX_PERSONAL] trim];
            board.numberOfAllTopics = [topicNumber integerValue];

            [tempBoards setObject:board forKey:[NSString stringWithFormat:@"board%ld", (long)index++]];
        }
        if (block) { block(tempBoards, nil); }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];
}

@end
