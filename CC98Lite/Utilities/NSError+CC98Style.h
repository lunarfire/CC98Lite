//
//  NSError+CC98Style.h
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CC98ErrorStyle){
    CC98UsernameEmpty,  // 输入的用户名为空
    CC98PasswordEmpty,  // 输入的密码为空
    CC98UsernameNotExisted,  // 用户名不存在
    CC98AccountIncorrect,  // 用户名密码错误
    CC98ExceedTailPage,  // 超过尾页
    CC98ExceedHeadPage,  // 超过首页
    CC98DeleteMessageFailed,  // 站短删除失败
    CC98SendMessageFailed,  // 站短发送失败
    CC98PublishPostFailed  // 帖子发表失败
};


@interface NSError (CC98Style)

+ (NSString *)cc98ErrorDomain;
+ (instancetype)errorWithCode:(NSInteger)code description:(NSString *)description;

@end
