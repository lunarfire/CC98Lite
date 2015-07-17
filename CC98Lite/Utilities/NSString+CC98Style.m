//
//  NSString+CC98Style.m
//  CC98Lite
//
//  Created by S on 15/6/8.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "NSString+CC98Style.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CC98Style)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) md5_32 {
    const char *utf8String = [self UTF8String];
    unsigned char result[16];
    CC_MD5(utf8String, (unsigned int)strlen(utf8String), result);
    
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

- (NSString *)md5_16 {
    const char *utf8String = [self UTF8String];
    unsigned char result[16];
    CC_MD5(utf8String, (unsigned int)strlen(utf8String), result);
    
    NSMutableString *hash =[NSMutableString string];
    for (int i = 4; i < 12; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }

    return hash;
}

- (BOOL)isIntegerValue {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)removeBlankChars {
    return [self replaceMatchRegex:@"[\\r\\n\\t]" withString:@""];
}

- (NSArray *)everyMatchRegex:(NSString *)pattern {
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        NSString *result = [self substringWithRange:match.range];
        [results addObject:result];
    }

    return results;
}

- (NSString *)firstMatchRegex:(NSString *)pattern {
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (range.location == NSNotFound) {
        return nil;
    } else {
        return [self substringWithRange:range];
    }
}

- (NSString *)replaceMatchRegex:(NSString *)pattern withString:(NSString *)target {
    NSMutableString *content = [NSMutableString stringWithString:self];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    [regex replaceMatchesInString:content options:0 range:NSMakeRange(0, content.length) withTemplate:target];
    return content;
}

+ (NSString *)showStringSafely:(NSString *)info {
    return info ? info : @"";
}

@end
