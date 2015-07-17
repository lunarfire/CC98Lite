//
//  CC98User.h
//  CC98Lite
//
//  Created by S on 15/6/20.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CC98UserInfo;


@interface CC98User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *portrait;
@property (strong, nonatomic) NSString *grade;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *numberOfArticles;

+ (NSArray *)usersWithCondition:(NSString *)condition;
+ (CC98UserInfo *)newUser;
+ (BOOL)saveInDatabase;

@end
