//
//  CC98Board.h
//  CC98Lite
//
//  Created by S on 15/5/25.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface CC98Board : NSObject

@property (weak, readonly) NSString *address;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSArray *moderators;
@property (strong, nonatomic) NSString *latestReplyTopicName;
@property (strong, nonatomic) NSString *latestReplyTime;
@property (strong, nonatomic) NSString *latestReplierName;
@property (assign, nonatomic) NSInteger numberOfPostsToday;
@property (assign, nonatomic) NSInteger numberOfAllTopics;
@property (assign, nonatomic) NSInteger numberOfAllPosts;
@property (assign, readonly) NSInteger numberOfPages;
@property (assign, nonatomic) NSInteger currentPageNum;

- (void)topicsInPage:(NSInteger)pageNum withBlock:(void (^)(NSArray *topics, NSError *error))block;

+ (UIImage *)icon;

@end
