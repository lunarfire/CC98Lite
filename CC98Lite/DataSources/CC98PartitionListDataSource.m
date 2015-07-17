//
//  CC98PartitionListDataSource.m
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98PartitionListDataSource.h"
#import "CC98Forum.h"
#import "CC98CommonPartition.h"
#import "UITableViewCell+CC98Style.h"
#import "CC98BlockListTableViewCell.h"
#import "CC98PartitionDataDelegate.h"
#import "CC98CommonBoardListDataSource.h"
#import "CC98BlockListTableViewController.h"

@interface CC98PartitionListDataSource ()

@property (strong, nonatomic) NSArray *partitions;

@end

#import "CC98PartitionListDataSource.h"

@implementation CC98PartitionListDataSource

#pragma mark - BlockListDataSource

- (NSString *)navigationBarName {
    return @"版面分类";
}

- (void)updateWithBlock:(void (^)(NSError *error))block {
    [[CC98Forum sharedInstance] commonPartitionsWithBlock:^(NSArray *partitions, NSError *error) {
        if (!error) {
            self.partitions = partitions;
        }
        if (block) { block(error); }
    }];
}

- (void)resetDataSource {
    self.partitions = nil;
}

- (BOOL)hasMultiplePages {
    return NO;
}

- (BOOL)hasNavigationBarMenu {
    return NO;
}

- (BOOL)hasTableHeaderView {
    return NO;
}

- (CC98CommonPartition *)partitionForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.partitions count]) {
        return nil;
    } else {
        return [self.partitions objectAtIndex:(NSUInteger)indexPath.row];
    }
}

- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98BlockListTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"blockListTableView"];
    
    CC98CommonBoardListDataSource *dataSource = [[CC98CommonBoardListDataSource alloc] init];
    dataSource.partition = [self partitionForIndexPath:indexPath];
    
    viewController.dataSource = dataSource;
    return viewController;
}

- (void) configureCell:(CC98BlockListTableViewCell *)cell forRowAtIndex:(NSIndexPath *)indexPath {
    CC98PartitionDataDelegate *partitionData = [[CC98PartitionDataDelegate alloc] init];
    partitionData.partition = [self partitionForIndexPath:indexPath];
    cell.blockData = partitionData;
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
    return (NSInteger)[self.partitions count];
}



@end
