//
//  CC98NewPost.m
//  CC98Lite
//
//  Created by S on 15/6/15.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98NewPost.h"
#import "CC98Client.h"
#import "CC98Account.h"

@implementation CC98NewPost

- (NSDictionary *)newPostInfo {
    return @{
             @"upfilerename":@"",
             @"username":[[[CC98Client sharedInstance] currentAccount] name],
             @"passwd":[[[CC98Client sharedInstance] currentAccount] passwd_md5_16],
             @"subject":self.title,
             @"Expression":@"face7.gif",
             @"Content":self.content,
             @"signflag":@"yes"
    };
}

- (NSString *)replyAddress {
    return [NSString stringWithFormat:@"SaveAnnounce.asp?boardID=%@", self.boardID];
}

- (NSString *)replyInfoAddress {
    return [NSString stringWithFormat:@"announce.asp?boardid=%@", self.boardID];
}

- (void)postWithBlock:(void (^)(NSError *error))block {
    NSDictionary *postData = [self newPostInfo];
    [self realPostWithReplyData:postData withBlock:block];
}

@end
