//
//  CC98TopicListDataSource.m
//  CC98Lite
//
//  Created by S on 15/6/4.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98TopicListDataSource.h"
#import "CC98TopicListTableViewCell.h"
#import "UITableViewCell+CC98Style.h"
#import "CC98PostListViewController.h"
#import "NSError+CC98Style.h"
#import "CC98Board.h"
#import "CC98Topic.h"
#import "CC98NewPost.h"

@interface CC98TopicListDataSource ()

@property (strong, nonatomic) NSArray *topics;

@end


@implementation CC98TopicListDataSource

#pragma mark - BlockListDataSource

- (NSString *)navigationBarName {
    if (!self.board) {
        return @"";
    } else {
        if (self.board.numberOfPages == 0) {
            return self.board.name;
        } else {
            return [NSString stringWithFormat:@"%@ (%ld/%ld)", self.board.name, (long)(self.board.currentPageNum), (long)(self.board.numberOfPages)];
        }
    }
}

- (void)resetDataSource {
    self.topics = nil;
    self.board.currentPageNum = 1;
}

- (BOOL)hasMultiplePages {
    return YES;
}

- (BOOL)hasNavigationBarMenu {
    return YES;
}

- (BOOL)hasTableHeaderView {
    return NO;
}

- (CC98Post *)postForNewTopic {
    CC98NewPost *newPost = [[CC98NewPost alloc] init];
    newPost.boardID = self.board.identifier;
    
    return newPost;
}

- (void)updateWithBlock:(void (^)(NSError *error))block {
    [self.board topicsInPage:self.board.currentPageNum withBlock:^(NSArray *topics, NSError *error) {
        if (!error) {
            self.topics = topics;
        }
        if (block) { block(error); }
    }];
}

- (void)loadNextPageWithBlock:(void (^)(NSError *error))block {
    if (self.board.currentPageNum >= self.board.numberOfPages) {
        if (block) { block([NSError errorWithCode:CC98ExceedTailPage description:@"已经到最后一页啦"]); }
        return;
    }

    ++self.board.currentPageNum;
    [self updateWithBlock:block];
}

- (void)loadPrevPageWithBlock:(void (^)(NSError *error))block {
    if (self.board.currentPageNum <= 1) {
        if (block) { block([NSError errorWithCode:CC98ExceedHeadPage description:@"已经到第一页啦"]); }
        return;
    }
    
    --self.board.currentPageNum;
    [self updateWithBlock:block];
}

- (CC98Topic *)topicForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.topics count]) {
        return nil;
    } else {
        return [self.topics objectAtIndex:(NSUInteger)indexPath.row];
    }
}

- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98PostListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"postListWebView"];
    
    viewController.topic = [self topicForIndexPath:indexPath];
    return viewController;
}

- (void) configureCell:(CC98TopicListTableViewCell *)cell forRowAtIndex:(NSIndexPath *)indexPath {
    cell.topic = [self topicForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightOfCellAtIndexPath:(NSIndexPath *)indexPath {
    static CC98TopicListTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = (CC98TopicListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TopicListTableViewCell"];
    });
    [self configureCell:sizingCell forRowAtIndex:indexPath];
    
    static const CGFloat kPaddingHeight = 10.0f;
    return [sizingCell calculateHeightOfCellWithTableViewFrame:tableView.frame] + kPaddingHeight;
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
    return (NSInteger)[self.topics count];
}

@end
