//
//  CC98ControlPanelDataSource.m
//  CC98Lite
//
//  Created by S on 15/6/18.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98ControlPanelDataSource.h"
#import "UITableViewCell+CC98Style.h"
#import "CC98MessageListTableViewController.h"
#import "CC98AccountListTableViewController.h"
#import "CC98BlockListTableViewCell.h"
#import "CC98UserProfileTableViewController.h"
#import "CC98SettingsTableViewController.h"
#import "CC98AboutViewController.h"
#import "CC98Client.h"
#import "CC98Account.h"
#import "CC98MessageInbox.h"
#import "CC98MessageOutbox.h"


@interface CC98ControlPanelDataSource ()

@property (strong, readonly) NSArray *panelItems;

@end

@implementation CC98ControlPanelDataSource

@synthesize panelItems = _panelItems;

- (NSArray *)panelItems {
    if (!_panelItems) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CC98MessageListTableViewController *itemInbox = [storyboard instantiateViewControllerWithIdentifier:@"messageList"];
        itemInbox.messageBox = [[CC98MessageInbox alloc] init];
        
        CC98MessageListTableViewController *itemOutbox = [storyboard instantiateViewControllerWithIdentifier:@"messageList"];
        itemOutbox.messageBox = [[CC98MessageOutbox alloc] init];
        
        CC98AccountListTableViewController *itemAccount = [storyboard instantiateViewControllerWithIdentifier:@"accountList"];
        CC98SettingsTableViewController *itemSettings = [storyboard instantiateViewControllerWithIdentifier:@"settingsList"];
        CC98AboutViewController *itemAbout = [storyboard instantiateViewControllerWithIdentifier:@"aboutText"];

        _panelItems = @[
                       @[itemInbox, itemOutbox],
                       @[itemAccount, itemSettings, itemAbout]
        ];
        
    }
    return _panelItems;
}

- (NSString *)navigationBarName {
    return @"个人相关";
}

- (void)resetDataSource {
    
}

- (BOOL)hasMultiplePages {
    return NO;
}

- (BOOL)hasNavigationBarMenu {
    return NO;
}

- (BOOL)hasTableHeaderView {
    return YES;
}

- (void)updateWithBlock:(void (^)(NSError *error))block {
    if (block) { block(nil); }
}

- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    
    if (!indexPath) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        if ([[CC98Client sharedInstance] currentAccount] != nil) {
            CC98UserProfileTableViewController *userProfileTVC = [storyboard instantiateViewControllerWithIdentifier:@"userProfileTableView"];
            userProfileTVC.userName = [[[CC98Client sharedInstance] currentAccount] name];
            userProfileTVC.userPortrait = [[[CC98Client sharedInstance] currentAccount] portrait];
            viewController = userProfileTVC;
        } else {
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"loginForTableView"];
        }
    } else {
        if ([[CC98Client sharedInstance] hasLoggedIn]) {
            return self.panelItems[indexPath.section][indexPath.row];
        } else {
            return self.panelItems[indexPath.section+1][indexPath.row];
        }
    }
    
    return viewController;
}

- (id<CC98BlockDataDelegate>)panelItemForIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    if ([[CC98Client sharedInstance] hasLoggedIn]) {
        return self.panelItems[indexPath.section][indexPath.row];
    } else {
        return self.panelItems[indexPath.section+1][indexPath.row];
    }
}

- (void) configureCell:(CC98BlockListTableViewCell *)cell forRowAtIndex:(NSIndexPath *)indexPath {
    cell.blockData = [self panelItemForIndexPath:indexPath];
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
    if ([[CC98Client sharedInstance] hasLoggedIn]) {
        return [self.panelItems count];
    } else {
        return [self.panelItems count]-1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[CC98Client sharedInstance] hasLoggedIn]) {
        return [self.panelItems[section] count];
    } else {
        return [self.panelItems[section+1] count];
    }
}


@end
