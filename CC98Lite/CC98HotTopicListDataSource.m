//
//  CC98HotTopicListDataSource.m
//  CC98Lite
//
//  Created by S on 15/6/27.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98HotTopicListDataSource.h"
#import "CC98PostListViewController.h"
#import "CC98TopicListTableViewCell.h"
#import "UITableViewCell+CC98Style.h"
#import "CC98HotTopicBoard.h"

@interface CC98HotTopicListDataSource ()

@property (strong, nonatomic) CC98HotTopicBoard *hotTopicBoard;
@property (strong, nonatomic) NSArray *hotTopics;

@end

@implementation CC98HotTopicListDataSource

- (CC98HotTopicBoard *)hotTopicBoard {
    if (!_hotTopicBoard) {
        _hotTopicBoard = [[CC98HotTopicBoard alloc] init];
    }
    return _hotTopicBoard;
}

#pragma mark - BlockListDataSource

- (NSString *)navigationBarName {
    return @"24小时热门话题";
}

- (BOOL)hasMultiplePages {
    return NO;
}

- (void)resetDataSource {
    self.hotTopics = nil;
    self.hotTopicBoard = nil;
}

- (BOOL)hasNavigationBarMenu {
    return NO;
}

- (BOOL)hasTableHeaderView {
    return NO;
}

- (void)updateWithBlock:(void (^)(NSError *error))block {
    [self.hotTopicBoard hotTopicsWithBlock:^(NSArray *hotTopics, NSError *error) {
        if (!error) {
            self.hotTopics = hotTopics;
        }
        if (block) { block(error); }
    }];
}

- (CC98Topic *)topicForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.hotTopics count]) {
        return nil;
    } else {
        return [self.hotTopics objectAtIndex:(NSUInteger)indexPath.row];
    }
}

- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98PostListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"postListWebView"];
    
    viewController.topic = [self topicForIndexPath:indexPath];
    return viewController;
}

- (void) configureCell:(CC98TopicListTableViewCell *) cell forRowAtIndex:(NSIndexPath *)indexPath {
    cell.topic = [self topicForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightOfCellAtIndexPath:(NSIndexPath *)indexPath {
    static CC98TopicListTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = (CC98TopicListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicListTableViewCell"];
    });
    [self configureCell:sizingCell forRowAtIndex:indexPath];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 11 + size.height;
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CC98TopicListTableViewCell *cell = (CC98TopicListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicListTableViewCell"];
    
    [self configureCell:cell forRowAtIndex:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)[self.hotTopics count];
}


@end
