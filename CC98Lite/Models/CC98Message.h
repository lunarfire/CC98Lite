//
//  CC98Message.h
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;


@interface CC98Message : NSObject

@property (assign, nonatomic) BOOL hasRead;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *person;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *prevMessageAddress;
@property (strong, nonatomic) NSString *nextMessageAddress;

+ (UIImage *)icon;

- (void)contentWithBlock:(void (^)(NSError *error))block;
- (void)deleteWithBlock:(void (^)(NSError *error))block;
- (void)sendWithBlock:(void (^)(NSError *error))block;

- (NSString *)repliedTitle;
- (NSString *)quotedContent;

@end
