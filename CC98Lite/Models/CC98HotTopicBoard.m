//
//  CC98HotTopicBoard.m
//  CC98Lite
//
//  Created by S on 15/6/27.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98HotTopicBoard.h"
#import <UIKit/UIKit.h>
#import "CC98Client.h"
#import "CC98Topic.h"
#import "NSString+CC98Style.h"
#import "CC98RegexRepository.h"

@implementation CC98HotTopicBoard

- (NSString *)address {
    return @"hottopic.asp";
}

- (NSString *)name {
    return @"24小时热门话题";
}

+ (UIImage *)icon {
    return [UIImage imageNamed:@"topic"];
}

- (void)hotTopicsWithBlock:(void (^)(NSArray *hotTopics, NSError *error))block {
    [[CC98Client sharedInstance] GET:self.address
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        content = [content removeBlankChars];
                                 
        NSArray *matches = [content everyMatchRegex:HOT_TOPIC_WRAPPER_REGEX];
        NSMutableArray *tempTopics = [NSMutableArray arrayWithCapacity:matches.count];
                                 
        for (NSString *match in matches) {
            CC98Topic *topic = [[CC98Topic alloc] init];
            
            topic.title = [match firstMatchRegex:HOT_TOPIC_TITLE_REGEX];
            NSString *authorRawString = [match firstMatchRegex:HOT_TOPIC_AUTHOR_RAW_REGEX];
            topic.authorName = [authorRawString firstMatchRegex:HOT_TOPIC_AUTHOR_NAME_REGEX];
            topic.latestReplyTime = [match firstMatchRegex:HOT_TOPIC_LATEST_REPLY_TIME];
            
            NSString *rawBoardName = [match firstMatchRegex:HOT_TOPIC_RAW_BOARD_NAME];
            topic.boardName = [rawBoardName firstMatchRegex:HOT_TOPIC_BOARD_NAME];
            
            NSArray *statisticData = [match everyMatchRegex:@"<TD align=middle class=tablebody1>\\d{1,10}</td>"];
            topic.numberOfReadTimes = [[statisticData[2] firstMatchRegex:@"(?<=class=tablebody1>)\\d{1,10}(?=</td>)"] integerValue];
            topic.numberOfReplies = [[statisticData[1] firstMatchRegex:@"(?<=class=tablebody1>)\\d{1,10}(?=</td>)"] integerValue];

            NSString *topicAddress = [match firstMatchRegex:HOT_TOPIC_ADDRESS_REGEX];
            topic.boardID = [topicAddress firstMatchRegex:HOT_TOPIC_BOARD_ID];
            topic.identifier = [topicAddress firstMatchRegex:HOT_TOPIC_IDENTIFIER];

            [topic setTopicStatus:match];
            [tempTopics addObject:topic];
        }
        if (block) { block([NSArray arrayWithArray:tempTopics], nil); }
                                 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];

}

@end
