//
//  CC98Post.h
//  CC98Lite
//
//  Created by S on 15/5/26.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CC98User;
@class CC98Topic;

@interface CC98Post : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) CC98User *author;
@property (strong, nonatomic) NSString *postTime;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *floorInfo;
@property (strong, nonatomic) NSString *quoteAddress;
@property (copy, nonatomic) NSString *boardID;
@property (weak, nonatomic) CC98Topic *topic;

- (NSString *)replyAddress;
- (NSString *)replyInfoAddress;
- (void)setRefererContent:(NSString *)value;

- (void)realPostWithReplyData:(NSDictionary *)postData withBlock:(void (^)(NSError *error))block;
- (void)postWithBlock:(void (^)(NSError *error))block;

@end
