//
//  CC98MessageOutbox.m
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98MessageOutbox.h"
#import "CC98Client.h"
#import "NSString+CC98Style.h"
#import "GTMNSString+HTML.h"
#import "CC98Message.h"

@implementation CC98MessageOutbox

@synthesize numberOfPages = _numberOfPages;

- (instancetype)init {
    if (self = [super init]) {
        self.numberOfPages = 1;
    }
    return self;
}

- (NSString *)title {
    return @"发件箱";
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"outbox"];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
}

- (NSInteger)numberOfPages {
    return _numberOfPages;
}

- (void)messagesInPage:(NSInteger)pageNum withBlock:(void (^)(NSArray *messages, NSError *error))block {
    [[CC98Client sharedInstance] GET:[NSString stringWithFormat:@"usersms.asp?action=issend&page=%ld", (long)pageNum]
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        NSString *messageNum = [content firstMatchRegex:@"(?<=总数<b>)\\d{0,10}(?=</b>)"];
        if (messageNum.length == 0) {
            self.numberOfPages = 1;
        } else {
            self.numberOfPages = ([messageNum integerValue]-1)/20+1;
        }

        NSArray *matches = [content everyMatchRegex:@"(?<=align=center valign=middle>)(.|\\r|\\n|\\t)*?(?=<td align=center valign=middle width=)"];
        NSMutableArray *tempMessages = [NSMutableArray arrayWithCapacity:matches.count];

        for (NSString *match in matches) {
            NSString *modified = [match removeBlankChars];

            CC98Message *message = [[CC98Message alloc] init];
            message.title = [[modified firstMatchRegex:@"(?<=resizable=yes,scrollbars=1'\\)\"    >).*?(?=</a></td>)"] gtm_stringByUnescapingFromHTML];
            message.hasRead = [modified firstMatchRegex:@"align=center valign=middle style=\"font-weight:bold\""] == nil ? YES : NO;

            NSString *rawPerson = [modified firstMatchRegex:@"(?<=align=center valign=middle style=).*?(?=</td>)"];
            message.person = [rawPerson firstMatchRegex:@"((?<=target=_blank>).*?(?=</a>))|(?<=<span style=\"color: gray;\">).*?(?=</span>)"];
            message.time = [modified firstMatchRegex:@"(?<=target=_blank>)\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}(?=</a></td>)"];
            message.address = [modified firstMatchRegex:@"(?<=window\\.open\\(').*?(?=','new_win')"];

            [tempMessages addObject:message];
        }
        if (block) { block([NSArray arrayWithArray:tempMessages], nil); }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(nil, error); }
    }];
}

@end
