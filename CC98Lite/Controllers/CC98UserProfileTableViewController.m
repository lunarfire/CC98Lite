//
//  CC98UserProfileTableViewController.m
//  CC98Lite
//
//  Created by S on 15/6/29.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98UserProfileTableViewController.h"
#import "CC98ControlPanelHeaderView.h"
#import "CC98UserProfile.h"
#import "UIColor+CC98Style.h"
#import "MBProgressHUD.h"

@interface CC98UserProfileTableViewController ()

@property (strong, nonatomic) CC98ControlPanelHeaderView *headerView;
@property (strong, nonatomic) CC98UserProfile *userProfile;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CC98UserProfileTableViewController

- (CC98UserProfile *)userProfile {
    if (!_userProfile) {
        _userProfile = [[CC98UserProfile alloc] init];
    }
    return _userProfile;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:self.hud];
    [self.hud hide:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView = nil;
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] init];
    tempBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempBarButtonItem;
    self.navigationItem.title = @"个人资料";

    self.headerView = [[CC98ControlPanelHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 110)
                                                               andBlock:nil];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.hud show:YES];
    [self.userProfile updateForUserName:self.userName andBlock:^(NSError *error) {
        [self.hud hide:YES];
        if (!error) {
            [self.headerView updateWithUserName:self.userName andUserImage:self.userPortrait];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userProfile.profile.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.userProfile.profile[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userProfileCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.userProfile.profile[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.userProfile.profileDetails[indexPath.section][cell.textLabel.text];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    view.backgroundColor = [UIColor mediumGreyColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

@end
