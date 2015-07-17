//
//  CC98Account.h
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC98User.h"

typedef NS_ENUM(NSInteger, CC98AccountStatus){
    CC98AccessNormal,  // 正常登录
    CC98AccessHidden   // 隐身登录
};

@interface CC98Account : CC98User

@property (strong, nonatomic) NSString *passwd_md5_16;
@property (strong, nonatomic) NSString *passwd_md5_32;

- (instancetype)initWithUsername:(NSString *)name andPassword:(NSString *)password;
- (instancetype)initWithStoredInformationUsingUsername:(NSString *)name;
- (void)checkValidWithError:(NSError **)error;

- (void)loginWithBlock:(void (^)(NSError *error))block;
- (void)logout;

- (void)storePasswordSafely;

@end
