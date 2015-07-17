//
//  CC98TopicListDataSource.h
//  CC98Lite
//
//  Created by S on 15/6/4.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CC98BlockListDataSource.h"

@class CC98Board;
@class CC98Topic;


@interface CC98TopicListDataSource : NSObject <UITableViewDataSource, CC98BlockListDataSource>

@property (strong, nonatomic) CC98Board *board;

- (CC98Topic *)topicForIndexPath:(NSIndexPath *)indexPath;

@end
