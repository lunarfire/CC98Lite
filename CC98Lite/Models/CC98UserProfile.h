//
//  CC98UserProfile.h
//  CC98Lite
//
//  Created by S on 15/6/29.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CC98UserProfile : NSObject

@property (strong, nonatomic) NSArray *profile;
@property (strong, nonatomic) NSArray *profileDetails;

- (void)updateForUserName:(NSString *)name andBlock:(void (^)(NSError *error))block;

@end
