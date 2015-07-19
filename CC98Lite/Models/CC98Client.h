//
//  CC98Client.h
//  CC98Lite
//
//  Created by S on 15/5/24.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@class CC98Account;

#define TEST_ACCOUNT @"lunarfire"


@interface CC98Client : AFHTTPSessionManager

+ (CC98Client *)sharedInstance;

+ (void)useProxy;
+ (void)useCampusNet;

+ (NSURL *)address;
+ (NSURL *)proxyAddress;
+ (NSString *)serviceName;

+ (NSString *)addressString;
+ (NSString *)proxyAddressString;

- (BOOL)hasLoggedIn;

@property (strong, nonatomic) CC98Account *currentAccount;

@end
