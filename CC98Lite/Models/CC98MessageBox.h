//
//  CC98MessageBox.h
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;


@protocol CC98MessageBox <NSObject>

@property (weak, readonly) NSString *title;
@property (weak, readonly) UIImage *icon;
@property (assign, nonatomic) NSInteger numberOfPages;

- (void)messagesInPage:(NSInteger)pageNum withBlock:(void (^)(NSArray *messages, NSError *error))block;

@end
