//
//  CC98AccountListTableViewController.m
//  CC98Lite
//
//  Created by S on 15/6/18.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98AccountListTableViewController.h"
#import "CC98Account.h"
#import "CC98UserInfo.h"
#import "CC98Client.h"
#import "UIImageView+WebCache.h"
#import "STKeychain.h"
#import "CC98LoginViewController.h"


@interface CC98AccountListTableViewController ()

@property (strong, nonatomic) NSMutableArray *accounts;

@end


@implementation CC98AccountListTableViewController

- (NSString *)name {
    return @"帐号管理";
}

- (NSString *)info {
    return @"";
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"user"];
}

- (NSMutableArray *)fetchAccounts {
    NSArray *users = [CC98User usersWithCondition:nil];
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithCapacity:users.count];
    
    for (CC98UserInfo *user in users) {
        CC98Account *account = [[CC98Account alloc] initWithStoredInformationUsingUsername:user.name];
        account.portrait = user.portrait;
        
        [accounts addObject:account];
    }

    return accounts;
}

- (NSMutableArray *)accounts {
    if (!_accounts) {
        _accounts = [self fetchAccounts];
    }
    return _accounts;
}

- (void)addNewAccount {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98LoginViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"loginForTableView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.accounts = [self fetchAccounts];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] init];
    tempBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempBarButtonItem;
    self.navigationItem.title = @"帐号列表";
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"adduser"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(addNewAccount)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountListCell" forIndexPath:indexPath];
    
    CC98Account *account = self.accounts[indexPath.row];
    cell.textLabel.text = account.name;
    
    UIImageView *userImage = cell.imageView;
    [userImage sd_setImageWithURL:[NSURL URLWithString:account.portrait] placeholderImage:[UIImage imageNamed:@"user"]];
    
    CC98Account *currentAccount = [[CC98Client sharedInstance] currentAccount];
    if (currentAccount != nil) {
        if ([currentAccount.name isEqualToString:account.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.accounts[indexPath.row] loginWithBlock:^(NSError *error) {
        if (!error) {
            [tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
