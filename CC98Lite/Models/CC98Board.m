//
//  CC98Board.m
//  CC98Lite
//
//  Created by S on 15/5/25.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98Board.h"
#import "CC98Topic.h"
#import "CC98Client.h"
#import "GTMNSString+HTML.h"
#import "NSError+CC98Style.h"
#import "NSString+CC98Style.h"
#import "CC98RegexRepository.h"

@implementation CC98Board

- (instancetype)init {
    if (self = [super init]) {
        self.currentPageNum = 1;
    }
    return self;
}

+ (UIImage *)icon {
    return [UIImage imageNamed:@"board"];
}

- (NSString *)address {
    return [NSString stringWithFormat:@"list.asp?boardid=%@", self.identifier];
}

@dynamic numberOfPages;

- (NSInteger)numberOfPages {
    return (self.numberOfAllTopics-1)/20 + 1;
}

- (void)topicsInPage:(NSInteger)pageNum withBlock:(void (^)(NSArray *topics, NSError *error))block {
    NSAssert(pageNum<=self.numberOfPages && pageNum>=1, @"主题列表页面数超过范围");
    
    [[CC98Client sharedInstance] GET:[NSString stringWithFormat:@"%@&page=%ld", self.address, (long)pageNum]
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
             
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        content = [content removeBlankChars];
             
        NSArray *matches = [content everyMatchRegex:TOPIC_WRAPPER_REGEX];
        NSMutableArray *tempTopics = [NSMutableArray arrayWithCapacity:matches.count];
             
        for (NSString *match in matches) {
            CC98Topic *topic = [[CC98Topic alloc] init];
            
            NSString *titleRawString = [[match firstMatchRegex:TOPIC_TITLE_RAW_REGEX] gtm_stringByUnescapingFromHTML];
            topic.title = [titleRawString firstMatchRegex:TOPIC_TITLE_TEXT_REGEX];
            NSString *authorRawString = [match firstMatchRegex:TOPIC_AUTHOR_RAW_REGEX];
            topic.authorName = [authorRawString firstMatchRegex:TOPIC_AUTHOR_NAME_REGEX_1];
            if (!topic.authorName) {
                topic.authorName = [authorRawString firstMatchRegex:TOPIC_AUTHOR_NAME_REGEX_2];
            }
            
            NSString *numberOfReadAndReply = [match firstMatchRegex:TOPIC_READ_REPLY_NUM];
            topic.numberOfReadTimes = [[numberOfReadAndReply firstMatchRegex:TOPIC_ONLY_READ_NUM] integerValue];
            topic.numberOfReplies = [[numberOfReadAndReply firstMatchRegex:TOPIC_ONLY_REPLY_NUM] integerValue];
            topic.latestReplyTime = [match firstMatchRegex:TOPIC_LATEST_REPLY_TIME];
            
            NSString *identifierWrapper = [match firstMatchRegex:TOPIC_ID_WRAPPER_REGEX];
            topic.identifier = [identifierWrapper firstMatchRegex:TOPIC_ID_REGEX];
            topic.boardID = [identifierWrapper firstMatchRegex:TOPIC_BOARD_ID_REGEX];
            
            [topic setTopicStatus:match];
            [tempTopics addObject:topic];
        }
        if (block) { block([NSArray arrayWithArray:tempTopics], nil); }
             
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];
}

@end
