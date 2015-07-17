//
//  CC98CommonPartition.m
//  CC98Lite
//
//  Created by S on 15/6/1.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98CommonPartition.h"
#import "UIKit/UIKit.h"
#import "CC98Client.h"
#import "NSString+CC98Style.h"
#import "CC98RegexRepository.h"
#import "CC98Board.h"
#import "GTMNSString+HTML.h"

@implementation CC98CommonPartition

- (NSString *)address {
    return [NSString stringWithFormat:@"list.asp?boardid=%@", self.identifier];
}

+ (UIImage *)icon {
    return [UIImage imageNamed:@"partition"];
}

- (void)boardsOrPartitionsWithBlock:(void (^)(NSDictionary *boardsOrPartitions, NSError *error))block {
    
    [[CC98Client sharedInstance] GET:self.address
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        NSArray *matches = [content everyMatchRegex:BOARD_WRAPPER_REGEX];
        NSMutableDictionary *tempBoardsOrPartitions = [NSMutableDictionary dictionaryWithCapacity:matches.count];

        NSInteger index = 0;
        for (NSString *match in matches) {
            if ([match rangeOfString:@"个下属论坛"].length > 0) {
                CC98CommonPartition *partition = [[CC98CommonPartition alloc] init];
                partition.name = [[match firstMatchRegex:PARTITION_NAME_REGEX] gtm_stringByUnescapingFromHTML];
                partition.numberOfBoards = [[match firstMatchRegex:@"(?<=下属论坛\">\\()\\d{1,2}(?=\\)</span>)"] integerValue];
                partition.identifier = [match firstMatchRegex:PARTITION_ID_REGEX];

                [tempBoardsOrPartitions setObject:partition forKey:[NSString stringWithFormat:@"partition%ld", (long)index++]];
            } else {
                CC98Board *board = [[CC98Board alloc] init];
                board.name = [[match firstMatchRegex:BOARD_NAME_REGEX] gtm_stringByUnescapingFromHTML];
                board.numberOfPostsToday = [[match firstMatchRegex:BOARD_POSTS_NUM_REGEX] integerValue];
                board.identifier = [match firstMatchRegex:BOARD_ID_REGEX];
                board.numberOfAllTopics = [[[match firstMatchRegex:BOARD_TOPICS_NUM_REGEX] trim] integerValue];

                [tempBoardsOrPartitions setObject:board forKey:[NSString stringWithFormat:@"board%ld", (long)index++]];
            }
        }
        if (block) { block(tempBoardsOrPartitions, nil); }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];
}


@end
