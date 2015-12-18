//
//  CC98Account.m
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98Account.h"
#import "NSError+CC98Style.h"
#import "NSString+CC98Style.h"
#import "CC98Client.h"
#import "STKeychain.h"
#import "AppDelegate.h"
#import "CC98UserInfo.h"

@interface CC98Account ()

@end


@implementation CC98Account

@synthesize passwd_md5_16;
@synthesize passwd_md5_32;

- (instancetype)initWithUsername:(NSString *)name andPassword:(NSString *)password {
    if (self = [super init]) {
        self.name = [name trim];
        self.passwd_md5_16 = [[password trim] md5_16];
        self.passwd_md5_32 = [[password trim] md5_32];
    }
    return self;
}

- (instancetype)initWithStoredInformationUsingUsername:(NSString *)name {
    if (self = [super init]) {
        self.name = [name trim];
        
        if (![self retrievePasswordSafely]) {
            self = nil;
        }
    }
    return self;
}

- (void)checkValidWithError:(NSError **)error {
    *error = nil;
    if (self.name.length == 0) {
        *error = [NSError errorWithCode:CC98UsernameEmpty description:@"您填写的用户名不能为空"];
    }
}

- (NSString *)loginAddress {
    return @"sign.asp";
}

- (NSString *)userManagerAddress {
    return @"usermanager.asp";
}

- (void)updateWithBlock:(void (^)(NSError *error))block {
    
    [[CC98Client sharedInstance] GET:[self userManagerAddress] parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {

            NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

            self.portrait = [content firstMatchRegex:@"(?<=<img src=[\'\"]).*?(?=[\'\"] width=)"];
            self.grade = [content firstMatchRegex:@"(?<=用户等级： ).*?(?=[\\s\\t\\n\\r]|<br>)"];
            self.numberOfArticles = [content firstMatchRegex:@"(?<=帖数总数： )\\d{1,10}(?=[\\s\\t\\n\\r]|<br>)"];
            
            [self savePermanently];
            [[CC98Client sharedInstance] setCurrentAccount:self];
                    
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate insertPersonalBoardsInTabBarIfNeeded];
            [appDelegate updatePersonalBoardsInTabBar];
                                  
            if (block) { block(nil); }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self.portrait = @"";
            self.grade = @"未知";
            self.numberOfArticles = @"未知";
            
            if (block) { block(error); }
    }];
}

- (void)logout {
    NSDictionary *logoutData = @{@"a":@"o"};
    
    [[CC98Client sharedInstance] POST:[self loginAddress] parameters:logoutData success:^(NSURLSessionDataTask *task, id responseObject) {
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)savePermanently {
    NSArray *users = [CC98User usersWithCondition:[NSString stringWithFormat:@"name == '%@'", self.name]];
    NSAssert(users.count <= 1, @"相同name的account最多有一个");
    
    CC98UserInfo *user = nil;
    if (users.count == 1) {
        user = users[0];
        user.portrait = self.portrait;
    } else {
        user = [CC98User newUser];
        user.name = self.name;
        user.portrait = self.portrait;
    }
    
    [CC98User saveInDatabase];
}

- (void)loginWithBlock:(void (^)(NSError *error))block {
    
    NSDictionary *loginData = @{@"a":@"i", @"u":self.name, @"p":self.passwd_md5_32, @"userhidden":@"2"};  // 登录时使用的参数
    
    [[CC98Client sharedInstance] POST:[self loginAddress] parameters:loginData success:^(NSURLSessionDataTask *task, id responseObject) {
        // 登录页面成功返回时的处理
        NSError *error = nil;
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
        if ([content rangeOfString:@"1003"].location != NSNotFound) {
            error = [NSError errorWithCode:CC98AccountIncorrect description:@"您填写的用户名密码错误"];
            if (block) { block(error); }
        } else if ([content rangeOfString:@"1001"].location != NSNotFound) {
            error = [NSError errorWithCode:CC98UsernameNotExisted description:@"您填写的用户名不存在"];
            if (block) { block(error); }
        } else {
            [self updateWithBlock:block];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 登录页面失败时的处理
        if (block) { block(error); }
    }];
}

- (void)storePasswordSafely {
    NSString *usernameFor16 = [NSString stringWithFormat:@"%@_16", self.name];
    NSString *usernameFor32 = [NSString stringWithFormat:@"%@_32", self.name];
    
    NSString *passwordFor16 = self.passwd_md5_16;
    NSString *passwordFor32 = self.passwd_md5_32;
    
    NSString *serviceName = [CC98Client serviceName];
    
    [STKeychain storeUsername:usernameFor16 andPassword:passwordFor16 forServiceName:serviceName updateExisting:YES error:NULL];
    [STKeychain storeUsername:usernameFor32 andPassword:passwordFor32 forServiceName:serviceName updateExisting:YES error:NULL];
}

- (BOOL)retrievePasswordSafely {
    NSString *usernameFor16 = [NSString stringWithFormat:@"%@_16", self.name];
    NSString *usernameFor32 = [NSString stringWithFormat:@"%@_32", self.name];
    
    NSString *serviceName = [CC98Client serviceName];
    
    self.passwd_md5_16 = [STKeychain getPasswordForUsername:usernameFor16 andServiceName:serviceName error:NULL];
    self.passwd_md5_32 = [STKeychain getPasswordForUsername:usernameFor32 andServiceName:serviceName error:NULL];
    
    if (self.passwd_md5_16 == nil || self.passwd_md5_32 == nil) {
        return NO;
    } else {
        return YES;
    }
}

@end
