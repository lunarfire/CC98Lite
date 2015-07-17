//
//  CC98QuotePost.h
//  CC98Lite
//
//  Created by S on 15/6/16.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98ReplyPost.h"

@interface CC98QuotePost : CC98ReplyPost

@property (weak, nonatomic) CC98Post *quotedPost;

- (NSString *)quotedContent;

@end
