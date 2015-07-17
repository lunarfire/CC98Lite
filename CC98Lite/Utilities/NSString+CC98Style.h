//
//  NSString+CC98Style.h
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CC98Style)

- (NSString *)trim;
- (NSString *) md5_32;
- (NSString *) md5_16;

- (BOOL)isIntegerValue;
- (NSString *)removeBlankChars;
- (NSArray *)everyMatchRegex:(NSString *)pattern;
- (NSString *)firstMatchRegex:(NSString *)pattern;
- (NSString *)replaceMatchRegex:(NSString *)pattern withString:(NSString *)target;

+ (NSString *)showStringSafely:(NSString *)info;

@end
