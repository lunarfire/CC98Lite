//
//  CC98Message.m
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98Message.h"
#import <UIKit/UIKit.h>
#import "CC98Client.h"
#import "NSError+CC98Style.h"
#import "NSString+CC98Style.h"

@interface CC98Message ()

@property (strong, nonatomic) NSString *deleteAddress;
@property (weak, readonly) NSString *sendAddress;

@end


@implementation CC98Message

+ (UIImage *)icon {
    return [UIImage imageNamed:@"message"];
}

- (NSString *)sendAddress {
    return @"messanger.asp?action=send";
}

- (void)contentWithBlock:(void (^)(NSError *error))block {
    [[CC98Client sharedInstance] GET:self.address
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
                                 
        if (!self.person) {
            NSString *personAndTime = [content firstMatchRegex:@"(在<b>\\d{2,4}-\\d{1,2}-\\d{1,2}.*?给您发送的消息)|(在<b>\\d{2,4}-\\d{1,2}-\\d{1,2}.*?您发送此消息给.*?</b>)"];
            self.person = [personAndTime firstMatchRegex:@"((?<=</b>，<b>).*?(?=</b>给您发送的消息))|((?<=</b>，您发送此消息给<b>).*?(?=</b>))"];
            self.time = [personAndTime firstMatchRegex:@"\\d{2,4}-\\d{1,2}-\\d{1,2} \\d{1,2}:\\d{1,2}:\\d{1,2}"];
            self.title = [content firstMatchRegex:@"(?<=<b>消息标题：).*?(?=</b><hr size)"];
        }

        self.content = [[content firstMatchRegex:@"<div id=\"ubbcode1\" >.*?<script>searchubb\\('ubbcode1',2,'tablebody2'\\);</script>"] trim];
        self.deleteAddress = [content firstMatchRegex:@"(?<=<a href=\")messanger\\.asp\\?action=delet&id=\\d{1,10}(?=\">)"];

        if ([content rangeOfString:@"阅读上一条消息"].location != NSNotFound) {
            NSString *prevMessageRaw = [content firstMatchRegex:@"<a href=\"\\?action=(outread|read)(.|\\r|\\n|\\t)*?阅读上一条消息"];
            self.prevMessageAddress = [prevMessageRaw firstMatchRegex:@"(?<=<a href=\")\\?action=(outread|read)&id=\\d{1,10}&(sender|incept)=.*?(?=\")"];
            self.prevMessageAddress = [NSString stringWithFormat:@"messanger.asp%@", self.prevMessageAddress];
        } else {
            self.prevMessageAddress = nil;
        }
        
        if ([content rangeOfString:@"阅读下一条消息"].location != NSNotFound) {
            NSString *nextMessageRaw = [content firstMatchRegex:@"阅读上一条消息(.|\\r|\\n|\\t)*?阅读下一条消息"];
            self.nextMessageAddress = [nextMessageRaw firstMatchRegex:@"(?<=<a href=\")\\?action=(outread|read)&id=\\d{1,10}&(sender|incept)=.*?(?=\")"];
            self.nextMessageAddress = [NSString stringWithFormat:@"messanger.asp%@", self.nextMessageAddress];
        } else {
            self.nextMessageAddress = nil;
        }

        if (block) { block(nil); }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(error); }
    }];
}

- (void)deleteWithBlock:(void (^)(NSError *error))block {
    [[CC98Client sharedInstance] GET:self.deleteAddress
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        if ([content rangeOfString:@"操作成功"].location != NSNotFound) {
            NSLog(@"短消息删除成功");
            if (block) { block(nil); }
        } else {
            NSError *error = [NSError errorWithCode:CC98DeleteMessageFailed description:@"短消息删除失败"];
            if (block) { block(error); }
        }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(error); }
    }];
}

- (void)sendWithBlock:(void (^)(NSError *error))block {
    NSDictionary *sendData = @{
        @"touser":self.person,
        @"title":self.title,
        @"message":self.content
    };
    
    [[CC98Client sharedInstance] POST:[self sendAddress]
                           parameters:sendData
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                 
        NSString *content = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        if ([content rangeOfString:@"操作成功"].location != NSNotFound) {
            NSLog(@"短消息发送成功");
            if (block) { block(nil); }
        } else if ([content rangeOfString:@"没有填写标题"].location != NSNotFound) {
            NSError *error = [NSError errorWithCode:CC98SendMessageFailed description:@"请填写短消息标题"];
            if (block) { block(error); }
        } else {
            NSError *error = [NSError errorWithCode:CC98SendMessageFailed description:@"短消息发送失败"];
            if (block) { block(error); }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) { block(error); }
    }];
}

- (NSString *)repliedTitle {
    if ([self.title firstMatchRegex:@"^RE\\(\\d{1,5}\\)"] != nil) {
        NSInteger repliedIndex = [[self.title firstMatchRegex:@"(?<=RE\\()\\d{1,5}(?=\\))"] integerValue];
        NSString *originalTitle = [self.title firstMatchRegex:[NSString stringWithFormat:@"(?<=RE\\(%ld\\))(.|\\r|\\n|\\t)*$", (long)repliedIndex]];
        
        return [NSString stringWithFormat:@"RE(%ld)%@", (long)++repliedIndex, originalTitle];
    } else {
        return [NSString stringWithFormat:@"RE(1) %@", self.title];
    }
}

- (NSString *)quotedContent {
    NSString *quote = [self.content replaceMatchRegex:@"\\[quote\\](.|\\r|\\n|\\t)*\\[/quote\\]" withString:@""];
    NSString *content = [NSString stringWithFormat:@"[quote][b]以下是引用您在[i]%@[/i]时发送的短信：[/b]\n%@\n[/quote]\n", self.time, quote];
    
    content = [content replaceMatchRegex:@"<br>" withString:@"\n"];
    content = [content replaceMatchRegex:@"<.*?>|searchubb.*?;" withString:@""];
    
    return content;
}

@end
