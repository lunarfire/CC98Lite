//
//  CC98BlockListTableViewController.m
//  CC98Lite
//
//  Created by S on 15/6/2.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BlockListTableViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "CC98EditPostViewController.h"
#import "SystemUtility.h"
#import "CC98Partition.h"
#import "CC98Client.h"
#import "CC98Account.h"
#import "NSError+CC98Style.h"
#import "UIColor+CC98Style.h"
#import "CC98ControlPanelHeaderView.h"
#import "MBProgressHUD.h"

@interface CC98BlockListTableViewController ()

@property (strong, nonatomic) CC98ControlPanelHeaderView *headerView;

@end

@implementation CC98BlockListTableViewController

- (void)swipeForNextPage:(UISwipeGestureRecognizer *)sender {
    if ([self.dataSource hasMultiplePages]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.dataSource loadNextPageWithBlock:^(NSError *error) {
            [self postProcessWithError:error];
            [hud hide:YES];
            
            if (!error) {
                if ([self.dataSource tableView:self.tableView numberOfRowsInSection:0] > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                [SystemUtility transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.view];
            }
        }];
    }
}

- (void)swipeForPrevPage:(id)sender {
    if ([self.dataSource hasMultiplePages]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.dataSource loadPrevPageWithBlock:^(NSError *error) {
            [self postProcessWithError:error];
            [hud hide:YES];
            
            if (!error) {
                if ([self.dataSource tableView:self.tableView numberOfRowsInSection:0] > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                [SystemUtility transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromLeft ForView:self.view];
            }
        }];
    }
}

- (void)postProcessWithError:(NSError *)error {
    if (!error) {
        [self.tableView reloadData];
        self.navigationItem.title = self.dataSource.navigationBarName;
    } else {
        if (error.code >= 0) {  // 仅给出自定义异常的提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    [self.refreshControl endRefreshing];
}

- (void)reload:(__unused id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.dataSource updateWithBlock:^(NSError *error) {
        [self postProcessWithError:error];
        [hud hide:YES];
    }];
}

- (void)setDataSource:(id<UITableViewDataSource,CC98BlockListDataSource>)dataSource {
    _dataSource = dataSource;
    self.navigationItem.title = self.dataSource.navigationBarName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView = nil;
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] init];
    tempBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempBarButtonItem;
    
    if ([self.dataSource hasNavigationBarMenu]) {
        UIBarButtonItem *postBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(postForNewTopic)];
        self.navigationItem.rightBarButtonItem = postBarButtonItem;
    }
    
    if ([self.dataSource hasTableHeaderView]) {
        __weak __typeof(self) weakSelf = self;
        self.headerView = [[CC98ControlPanelHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 110)
                                                                      andBlock:^{
                                                                          [weakSelf gotoNextViewController:nil];
                                                                      }];
        self.tableView.tableHeaderView = self.headerView;
    }
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeForNextPage:)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeForPrevPage:)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.dataSource hasTableHeaderView]) {
        if ([[CC98Client sharedInstance] currentAccount] != nil) {
            NSString *userName = [[[CC98Client sharedInstance] currentAccount] name];
            NSString *userAddress = [[[CC98Client sharedInstance] currentAccount] portrait];
            [self.headerView updateWithUserName:userName andUserImage:userAddress];
        } else {
            [self.headerView updateWithUserName:@"访客" andUserImage:@"user"];
        }
    }
    [self reload:nil];
}

- (void)postForNewTopic {
    if (![[CC98Client sharedInstance] hasLoggedIn]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"请您先登录，访客没有发帖回帖权限"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else if ([[[[CC98Client sharedInstance] currentAccount] name] isEqualToString:TEST_ACCOUNT]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"测试帐号没有发帖回帖权限"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CC98EditPostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editForPostView"];
        
        viewController.post = [self.dataSource postForNewTopic];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(BOOL)navigationShouldPopOnBackButton{
    [self.dataSource resetDataSource];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    return YES;
}

- (void)gotoNextViewController:(NSIndexPath *)indexPath {
    UIViewController *nextViewController = [self.dataSource nextViewControllerForIndexPath:indexPath];
    
    if (nextViewController) {
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self gotoNextViewController:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static const CGFloat TABLE_CELL_MARGIN = 5.0;
    return [self.dataSource tableView:tableView heightOfCellAtIndexPath:indexPath] + TABLE_CELL_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = nil;
    if ([self.dataSource numberOfSectionsInTableView:tableView] > 1 || [self.dataSource hasTableHeaderView]) {
        CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        view.backgroundColor = [UIColor mediumGreyColor];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.dataSource numberOfSectionsInTableView:tableView] > 1 || [self.dataSource hasTableHeaderView]) {
        return 20;
    } else {
        return 0;
    }
}

@end
