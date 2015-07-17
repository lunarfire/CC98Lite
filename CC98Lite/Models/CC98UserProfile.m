//
//  CC98UserProfile.m
//  CC98Lite
//
//  Created by S on 15/6/29.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98UserProfile.h"
#import "CC98Client.h"
#import "NSString+CC98Style.h"

@interface CC98UserProfile ()

@property (strong, nonatomic) NSMutableArray *accountInfo;
@property (strong, nonatomic) NSMutableDictionary *accountInfoDetails;
@property (strong, nonatomic) NSMutableArray *userInfo;
@property (strong, nonatomic) NSMutableDictionary *userInfoDetails;

@end


@implementation CC98UserProfile

static const NSUInteger DEFAULT_ACCOUNT_INFO_COUNT = 11;
static const NSUInteger DEFAULT_USER_INFO_COUNT = 3;

- (NSString *)address {
    return @"dispuser.asp";
}

- (NSMutableArray *)accountInfo {
    if (!_accountInfo) {
        _accountInfo = [NSMutableArray arrayWithCapacity:DEFAULT_ACCOUNT_INFO_COUNT];
    }
    return _accountInfo;
}

- (NSMutableDictionary *)accountInfoDetails {
    if (!_accountInfoDetails) {
        _accountInfoDetails = [NSMutableDictionary dictionaryWithCapacity:DEFAULT_ACCOUNT_INFO_COUNT];
    }
    return _accountInfoDetails;
}

- (NSMutableArray *)userInfo {
    if (!_userInfo) {
        _userInfo = [NSMutableArray arrayWithCapacity:DEFAULT_USER_INFO_COUNT];
    }
    return _userInfo;
}

- (NSMutableDictionary *)userInfoDetails {
    if (!_userInfoDetails) {
        _userInfoDetails = [NSMutableDictionary dictionaryWithCapacity:DEFAULT_USER_INFO_COUNT];
    }
    return _userInfoDetails;
}

- (NSArray *)profile {
    if (!_profile) {
        _profile = @[self.accountInfo, self.userInfo];
    }
    return _profile;
}

- (NSArray *)profileDetails {
    if (!_profileDetails) {
        _profileDetails = @[self.accountInfoDetails, self.userInfoDetails];
    }
    return _profileDetails;
}

- (void)addAccountInfoForItem:(NSString *)itemName withContent:(NSString *)content {
    [self.accountInfo addObject:itemName];
    
    if (!content) {
        [self.accountInfoDetails setObject:@"不存在" forKey:itemName];
    } else {
        NSString *regexCondition = [NSString stringWithFormat:@"(?<=%@：).*?(?=<br>)", itemName];
        [self.accountInfoDetails setObject:[NSString showStringSafely:[[content firstMatchRegex:regexCondition] trim]] forKey:itemName];
    }
}

- (void)updateForUserName:(NSString *)name andBlock:(void (^)(NSError *error))block {
    [[CC98Client sharedInstance] GET:[self address]
                          parameters:@{@"name":name}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
            NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                                 
            if ([content rangeOfString:@"您查询的名字不存在"].length > 0) {
                content = nil;
            }

            [self addAccountInfoForItem:@"用户头衔" withContent:content];
            [self addAccountInfoForItem:@"用户等级" withContent:content];
            [self addAccountInfoForItem:@"用户门派" withContent:content];
            [self addAccountInfoForItem:@"精华帖数" withContent:content];
            [self addAccountInfoForItem:@"帖数总数" withContent:content];
            [self addAccountInfoForItem:@"用户威望" withContent:content];
            [self addAccountInfoForItem:@"注册时间" withContent:content];
            [self addAccountInfoForItem:@"登录次数" withContent:content];
            [self addAccountInfoForItem:@"被删主题" withContent:content];
            [self addAccountInfoForItem:@"被删除率" withContent:content];
            [self addAccountInfoForItem:@"最后登录" withContent:content];
                                 
            if (!content) {
                [self.userInfo addObject:@"性 别"];
                [self.userInfoDetails setObject:@"不存在" forKey:@"性 别"];
                
                [self.userInfo addObject:@"生 日"];
                [self.userInfoDetails setObject:@"不存在" forKey:@"生 日"];
                
                [self.userInfo addObject:@"星 座"];
                [self.userInfoDetails setObject:@"不存在" forKey:@"星 座"];
                
            } else if ([content rangeOfString:@"此用户不愿公开其个人资料"].length == 0) {
                [self.userInfo addObject:@"性 别"];
                [self.userInfoDetails setObject:[NSString showStringSafely:[[content firstMatchRegex:@"(?<=性 别：).*?(?=<br>)"] trim]] forKey:@"性 别"];
                
                [self.userInfo addObject:@"生 日"];
                NSString *birthday = [[content firstMatchRegex:@"(?<=生 日： <font color=gray>).*?(?=</font>)"] trim];
                if (!birthday) {
                    birthday = [NSString showStringSafely:[[content firstMatchRegex:@"(?<=生 日：).*?(?=<br>)"] trim]];
                }
                [self.userInfoDetails setObject:birthday forKey:@"生 日"];
                
                [self.userInfo addObject:@"星 座"];
                [self.userInfoDetails setObject:[NSString showStringSafely:[[content firstMatchRegex:@"((?<=星 座： <font color=gray>).*?(?=</font>))|((?<=alt=\").*?(?= - \\d{2,4}年))|((?<=alt=\").*?(?= - \\d{1,2}月))"] trim]] forKey:@"星 座"];
            } else {
                [self.userInfo addObject:@"性 别"];
                [self.userInfoDetails setObject:@"未公开" forKey:@"性 别"];
                
                [self.userInfo addObject:@"生 日"];
                [self.userInfoDetails setObject:@"未公开" forKey:@"生 日"];
                
                [self.userInfo addObject:@"星 座"];
                [self.userInfoDetails setObject:@"未公开" forKey:@"星 座"];
            }

            if (block) { block(nil); }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) { block(error); }
    }];
}

@end
