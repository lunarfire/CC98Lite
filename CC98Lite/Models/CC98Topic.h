//
//  CC98Topic.h
//  CC98Lite
//
//  Created by S on 15/5/26.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CC98TopicStatus){
    CC98TopestTopic,  // 总固顶主题
    CC98TopTopic,  // 固顶主题
    CC98HotTopic,  // 热门主题
    CC98OpenTopic,  // 开放主题
    CC98SavedTopic,  // 保存帖子
    CC98EssentialTopic,  // 精华帖子
    CC98LockedTopic  // 锁定主题
};

@class UIImage;

@interface CC98Topic : NSObject

@property (weak, readonly) NSString *address;
@property (assign, nonatomic) CC98TopicStatus status;
@property (strong, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *boardID;
@property (copy, nonatomic) NSString *boardName;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *authorName;
@property (strong, nonatomic) NSString *latestReplyTime;
@property (strong, nonatomic) NSString *latestReplierName;
@property (assign, nonatomic) NSInteger numberOfReadTimes;
@property (assign, nonatomic) NSInteger numberOfReplies;
@property (assign, readonly) NSInteger numberOfPages;

- (void)postsInPage:(NSInteger)pageNum withBlock:(void (^)(NSArray *posts, NSError *error))block;
- (void)setTopicStatus:(NSString *)match;

+ (UIImage *)icon;

@end
