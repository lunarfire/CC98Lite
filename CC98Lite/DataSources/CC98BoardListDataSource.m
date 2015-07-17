//
//  CC98BoardListDataSource.m
//  CC98Lite
//
//  Created by S on 15/6/1.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BoardListDataSource.h"
#import "CC98Partition.h"
#import "UITableViewCell+CC98Style.h"
#import "CC98TopicListDataSource.h"
#import "CC98BoardDataDelegate.h"
#import "CC98PartitionDataDelegate.h"
#import "CC98BlockListTableViewCell.h"
#import "CC98CommonBoardListDataSource.h"
#import "CC98BlockListTableViewController.h"

@interface CC98BoardListDataSource ()

@property (strong, nonatomic) NSDictionary *boardsOrPartitions;

@end

@implementation CC98BoardListDataSource

#pragma mark - BlockListDataSource

- (NSString *)navigationBarName {
    if (!self.partition) {
        return @"";
    } else {
        return self.partition.name;
    }
}

- (BOOL)hasMultiplePages {
    return NO;
}

- (void)resetDataSource {
    self.boardsOrPartitions = nil;
}

- (BOOL)hasNavigationBarMenu {
    return NO;
}

- (BOOL)hasTableHeaderView {
    return NO;
}

- (void)updateWithBlock:(void (^)(NSError *error))block {
    [self.partition boardsOrPartitionsWithBlock:^(NSDictionary *boardsOrPartitions, NSError *error) {
        if (!error) {
            self.boardsOrPartitions = boardsOrPartitions;
        }
        if (block) { block(error); }
    }];
}

- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98BlockListTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"blockListTableView"];
    
    if (self.boardsOrPartitions[[NSString stringWithFormat:@"partition%ld", (long)(indexPath.row)]] != nil) {
        CC98CommonBoardListDataSource *dataSource = [[CC98CommonBoardListDataSource alloc] init];
        dataSource.partition = self.boardsOrPartitions[[NSString stringWithFormat:@"partition%ld", (long)(indexPath.row)]];
        viewController.dataSource = dataSource;
    } else {
        CC98TopicListDataSource *dataSource = [[CC98TopicListDataSource alloc] init];
        dataSource.board = self.boardsOrPartitions[[NSString stringWithFormat:@"board%ld", (long)(indexPath.row)]];
        viewController.dataSource = dataSource;
    }
    
    return viewController;
}

- (void) configureCell:(CC98BlockListTableViewCell *) cell forRowAtIndex:(NSIndexPath *)indexPath {
    
    if (self.boardsOrPartitions[[NSString stringWithFormat:@"partition%ld", (long)(indexPath.row)]] != nil) {
        CC98PartitionDataDelegate *partitionData = [[CC98PartitionDataDelegate alloc] init];
        partitionData.partition = self.boardsOrPartitions[[NSString stringWithFormat:@"partition%ld", (long)(indexPath.row)]];
        cell.blockData = partitionData;
    } else {
        CC98BoardDataDelegate *boardData = [[CC98BoardDataDelegate alloc] init];
        boardData.board = self.boardsOrPartitions[[NSString stringWithFormat:@"board%ld", (long)(indexPath.row)]];
        cell.blockData = boardData;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightOfCellAtIndexPath:(NSIndexPath *)indexPath {
    static CC98BlockListTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = (CC98BlockListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BlockListTableViewCell"];
    });
    
    [self configureCell:sizingCell forRowAtIndex:indexPath];
    return [sizingCell calculateHeightOfCellWithTableViewFrame:tableView.frame];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CC98BlockListTableViewCell *cell = (CC98BlockListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BlockListTableViewCell"];

    [self configureCell:cell forRowAtIndex:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.boardsOrPartitions count];
}


@end
