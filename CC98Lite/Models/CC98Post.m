//
//  CC98Post.m
//  CC98Lite
//
//  Created by S on 15/5/26.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98Post.h"
#import "CC98User.h"
#import "CC98Client.h"
#import "CC98Topic.h"
#import "NSString+CC98Style.h"
#import "NSError+CC98Style.h"

@implementation CC98Post

- (CC98User *)author {
    if (!_author) {
        _author = [[CC98User alloc] init];
    }
    return _author;
}

- (NSString *)floorInfo {
    if ([_floorInfo isEqualToString:@"楼主"] == NO) {
        return [NSString stringWithFormat:@"%@", _floorInfo];
    } else {
        return @"1";
    }
}

- (NSString *)replyAddress {
    NSAssert(NO, @"该方法不应被实现");
    return nil;
}

- (NSString *)replyInfoAddress {
    NSAssert(NO, @"该方法不应被实现");
    return nil;
}

- (void)realPostWithReplyData:(NSDictionary *)postData withBlock:(void (^)(NSError *error))block {
    
    [self setRefererContent:[NSString stringWithFormat:@"%@%@", [CC98Client address], [self replyInfoAddress]]];
    
    [[CC98Client sharedInstance] POST:[self replyAddress] parameters:postData
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
        NSString *html = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSRange status = [html rangeOfString:@"帖子成功"];
        NSRange errorTag = [html rangeOfString:@"论坛错误信息"];
                                  
        if (status.length == 0 || errorTag.length > 0) {
            if (block) {
                block([NSError errorWithCode:CC98PublishPostFailed description:@"发帖失败"]);
            }
        } else {
            if (block) { block(nil); }
        }
        [self setRefererContent:@""];
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self setRefererContent:@""];
    }];
}

- (void)setRefererContent:(NSString *)value {
    [[[CC98Client sharedInstance] requestSerializer] setValue:value forHTTPHeaderField:@"Referer"];
}

- (void)postWithBlock:(void (^)(NSError *error))block {
    NSAssert(NO, @"该方法不应被实现");
}

- (void)setTopic:(CC98Topic *)topic {
    _topic = topic;
    self.boardID = topic.boardID;
}

@end
