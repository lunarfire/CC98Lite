//
//  CC98HotTopicBoard.h
//  CC98Lite
//
//  Created by S on 15/6/27.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface CC98HotTopicBoard : NSObject

@property (weak, readonly) NSString *address;
@property (strong, nonatomic) NSString *name;

- (void)hotTopicsWithBlock:(void (^)(NSArray *hotTopics, NSError *error))block;

+ (UIImage *)icon;

@end
