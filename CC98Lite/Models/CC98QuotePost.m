//
//  CC98QuotePost.m
//  CC98Lite
//
//  Created by S on 15/6/16.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98QuotePost.h"
#import "NSString+CC98Style.h"
#import "CC98Topic.h"
#import "CC98User.h"

@implementation CC98QuotePost

- (NSString *)quotedContent {
    NSString *quote = [self.quotedPost.content replaceMatchRegex:@"\\[quotex\\](.|\\r|\\n|\\t)*\\[/quotex\\](\n|<BR>)" withString:@""];
    
    NSString *content = [NSString stringWithFormat:@"[quotex][b]以下是引用[i]%@在%@[/i]的发言：[/b]\n%@[/quotex]\n",
                         self.quotedPost.author.name, self.quotedPost.postTime, quote];

    content = [content replaceMatchRegex:@"<br>" withString:@"\n"];
    content = [content replaceMatchRegex:@"<.*?>|searchubb.*?;" withString:@""];
    
    return content;
}

- (NSString *)replyAddress {
    return [NSString stringWithFormat:@"SaveReAnnounce.asp?method=Topic&boardID=%@&bm=%@", self.topic.boardID, self.quotedPost.floorInfo];
}

- (NSString *)replyInfoAddress {
    return self.quotedPost.quoteAddress;
}


@end
