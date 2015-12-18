//
//  CC98Client.m
//  CC98Lite
//
//  Created by S on 15/5/24.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98Client.h"
#import "CC98Account.h"
#import "STKeychain.h"

@interface CC98Client ()

@property (nonatomic, assign) BOOL logInAlready;

@end


@implementation CC98Client

@synthesize currentAccount = _currentAccount;


+ (NSURL *)address {
    return [NSURL URLWithString:@"http://www.cc98.org/"];
}

+ (NSString *)addressString {
    return @"www.cc98.org";
}

+ (NSString *)serviceName {
    return @"MyCC98";
}

static CC98Client *sharedCC98Client = nil;

+ (CC98Client *)sharedInstance {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            sharedCC98Client = [[CC98Client alloc] initWithBaseURL:[CC98Client address]];
            sharedCC98Client.requestSerializer = [AFHTTPRequestSerializer serializer];
            sharedCC98Client.responseSerializer = [AFHTTPResponseSerializer serializer];
        });
    }
    return sharedCC98Client;
}

+ (void)useProxyWithAddress:(NSString *)proxyAddress {
    sharedCC98Client = [CC98Client sharedInstance];
    NSString *urlAddress = [NSString stringWithFormat:@"http://%@/", proxyAddress];
    
    sharedCC98Client = [[CC98Client alloc] initWithBaseURL:[NSURL URLWithString:urlAddress]];
    sharedCC98Client.requestSerializer = [AFHTTPRequestSerializer serializer];
    sharedCC98Client.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (NSString *)keyForCurrentAccount {
    return @"currentAccount.name";
}

- (void)setCurrentAccount:(CC98Account *)currentAccount {
    _currentAccount = currentAccount;
    self.logInAlready = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:_currentAccount.name forKey:[self keyForCurrentAccount]];
    [_currentAccount storePasswordSafely];
}

- (CC98Account *)currentAccount {
    if (!_currentAccount) {
        NSString *accountName = [[NSUserDefaults standardUserDefaults] stringForKey:[self keyForCurrentAccount]];
        if (!accountName) {
            _currentAccount = nil;
        } else {
            _currentAccount = [[CC98Account alloc] initWithStoredInformationUsingUsername:accountName]; 
        }
    }
    return _currentAccount;
}

- (BOOL)hasLoggedIn {
    return self.logInAlready;
}


@end
