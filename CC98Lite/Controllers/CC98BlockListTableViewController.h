//
//  CC98BlockListTableViewController.h
//  CC98Lite
//
//  Created by S on 15/6/2.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98BlockListDataSource.h"

@interface CC98BlockListTableViewController : UITableViewController

@property (strong, nonatomic) id<UITableViewDataSource, CC98BlockListDataSource> dataSource;

- (void)reload:(__unused id)sender;

@end
