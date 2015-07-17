//
//  CC98ReplyPost.m
//  CC98Lite
//
//  Created by S on 15/6/15.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98ReplyPost.h"
#import "CC98Client.h"
#import "CC98Topic.h"
#import "CC98Account.h"
#import "NSString+CC98Style.h"

@implementation CC98ReplyPost

- (NSString *)replyAddress {
    return [NSString stringWithFormat:@"SaveReAnnounce.asp?method=Topic&boardID=%@&bm=", self.topic.boardID];
}

- (NSString *)replyInfoAddress {
    return [NSString stringWithFormat:@"reannounce.asp?boardID=%@&ID=%@&star=%ld",
            self.topic.boardID, self.topic.identifier, (long)(self.topic.numberOfPages)];
}

- (NSDictionary *)parseHtmlForReplyInfo:(NSString *)content {

    NSString *followup = [content firstMatchRegex:@"(?<=name=\"followup\" value=\").*?(?=\")"];
    NSString *rootID = [content firstMatchRegex:@"(?<=name=\"rootID\" value=\").*?(?=\")"];
    NSString *star = [content firstMatchRegex:@"(?<=name=\"star\" value=\").*?(?=\")"];
    NSString *TotalUseTable = [content firstMatchRegex:@"(?<=name=\"TotalUseTable\" value=\").*?(?=\")"];
    NSString *replyID = [content firstMatchRegex:@"(?<=name=\"ReplyId\" type=\"hidden\" value=\").*?(?=\")"];
    
    return @{
             @"upfilerename":@"",
             @"followup":[NSString showStringSafely:followup],
             @"rootID":[NSString showStringSafely:rootID],
             @"star":[NSString showStringSafely:star],
             @"TotalUseTable":[NSString showStringSafely:TotalUseTable],
             @"ReplyId":[NSString showStringSafely:replyID],
             @"username":[NSString showStringSafely:[[[CC98Client sharedInstance] currentAccount] name]],
             @"passwd":[NSString showStringSafely:[[[CC98Client sharedInstance] currentAccount] passwd_md5_16]],
             @"subject":[NSString showStringSafely:self.title],
             @"Expression":@"face7.gif",
             @"Content":[NSString showStringSafely:self.content],
             @"signflag":@"yes"
    };
}

- (void)postWithBlock:(void (^)(NSError *error))block {
    
    [[CC98Client sharedInstance] GET:[self replyInfoAddress] parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *postData = [self parseHtmlForReplyInfo:content];

        [self realPostWithReplyData:postData withBlock:block];
         
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(error); }
    }];
}

@end
