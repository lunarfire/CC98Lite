//
//  CC98BlockListDataSource.h
//  CC98Lite
//
//  Created by S on 15/6/2.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CC98Post;


@protocol CC98BlockListDataSource <NSObject>

@required

@property (readonly, weak) NSString *navigationBarName;

- (void)resetDataSource;
- (BOOL)hasMultiplePages;

- (BOOL)hasNavigationBarMenu;
- (BOOL)hasTableHeaderView;

- (void)updateWithBlock:(void (^)(NSError *error))block;
- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightOfCellAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)loadNextPageWithBlock:(void (^)(NSError *error))block;
- (void)loadPrevPageWithBlock:(void (^)(NSError *error))block;

- (CC98Post *)postForNewTopic;

@end
