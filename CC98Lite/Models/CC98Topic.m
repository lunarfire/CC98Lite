//
//  CC98Topic.m
//  CC98Lite
//
//  Created by S on 15/5/26.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98Topic.h"
#import "CC98Post.h"
#import "CC98User.h"
#import "CC98Client.h"
#import "GTMNSString+HTML.h"
#import "NSString+CC98Style.h"
#import "CC98RegexRepository.h"

@implementation CC98Topic

+ (UIImage *)icon {
    return [UIImage imageNamed:@"topic"];
}

- (NSString *)address {
    return [NSString stringWithFormat:@"dispbbs.asp?boardID=%@&ID=%@", self.boardID, self.identifier];
}

@dynamic numberOfPages;

- (NSInteger)numberOfPages {
    return self.numberOfReplies/10+1;
}

- (void)setTopicStatus:(NSString *)match {
    if ([match rangeOfString:@"<span title=\"总固顶主题\">"].length > 0) {
        self.status = CC98TopestTopic;
    } else if ([match rangeOfString:@"<span title=\"区固顶主题\">"].length > 0) {
        self.status = CC98TopTopic;
    } else if ([match rangeOfString:@"<span title=\"固顶主题\">"].length > 0) {
        self.status = CC98TopTopic;
    } else if ([match rangeOfString:@"<span title=\"开放主题\">"].length > 0) {
        self.status = CC98OpenTopic;
    } else if ([match rangeOfString:@"<span title=\"精华帖\">"].length > 0) {
        self.status = CC98EssentialTopic;
    } else if ([match rangeOfString:@"<span title=\"保存帖\">"].length > 0) {
        self.status = CC98SavedTopic;
    } else if ([match rangeOfString:@"<span title=\"本主题已锁定\">"].length > 0) {
        self.status = CC98LockedTopic;
    } else {
        self.status = CC98OpenTopic;
    }
}

- (void)postsInPage:(NSInteger)pageNum withBlock:(void (^)(NSArray *posts, NSError *error))block {
    [[CC98Client sharedInstance] GET:[NSString stringWithFormat:@"%@&star=%ld&page=1", self.address, (long)pageNum]
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        NSArray *matches = [content everyMatchRegex:POST_WRAPPER_REGEX];
        NSMutableArray *tempPosts = [NSMutableArray arrayWithCapacity:matches.count];
                                 
        self.numberOfReplies = [[content firstMatchRegex:TOPIC_ALL_POST_NUM] integerValue] - 1;
        for (NSString *match in matches) {
            CC98Post *post = [[CC98Post alloc] init];
            post.content = [[match firstMatchRegex:POST_CONTENT_REGEX] trim];
            
            NSString *modified = [match removeBlankChars];
            post.title = [modified firstMatchRegex:POST_TITLE_REGEX];
            post.postTime = [modified firstMatchRegex:POST_TIME_REGEX];
            
            post.author.name = [[modified firstMatchRegex:POST_USER_NAME] gtm_stringByUnescapingFromHTML];
            post.author.gender = [modified firstMatchRegex:POST_USER_GENDER];
            post.author.portrait = [match firstMatchRegex:POST_USER_IMAGE];
            post.floorInfo = [modified firstMatchRegex:POST_FLOOR_INFO];
            post.quoteAddress = [modified firstMatchRegex:POST_QUOTE_ADDRESS];
            post.boardID = self.boardID;
            
            [tempPosts addObject:post];
        }
        if (block) { block([NSArray arrayWithArray:tempPosts], nil); }
                                 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];
}

@end
