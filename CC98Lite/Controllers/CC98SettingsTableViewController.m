//
//  CC98SettingsTableViewController.m
//  CC98Lite
//
//  Created by S on 15/6/29.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98SettingsTableViewController.h"

@interface CC98SettingsTableViewController ()

@end

@implementation CC98SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)name {
    return @"设置";
}

- (NSString *)info {
    return @"";
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"setting"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userSettingsCell" forIndexPath:indexPath];
    return cell;
}

@end
