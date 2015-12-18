//
//  CC98ReportViewController.m
//  CC98Lite
//
//  Created by S on 15/12/16.
//  Copyright © 2015年 zju. All rights reserved.
//

#import "CC98ReportViewController.h"
#import "CC98Message.h"

@interface CC98ReportViewController ()

@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation CC98ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = -1;
    
    self.navigationItem.title = @"举报";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelReport)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(proposeReport)];
    self.navigationItem.rightBarButtonItem = postButtonItem;
}

- (void)cancelReport {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)proposeReport {
    if (self.selectedIndex == -1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请选择举报理由"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
        [NSThread sleepForTimeInterval:0.8f];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"举报成功"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    /*
    CC98Message *newMessage = [[CC98Message alloc] init];
    
    newMessage.person = @"Auser";
    newMessage.title = [NSString stringWithFormat:@"举报该用户: %@", self.personToReport];
    
    NSString *reason = [@[@"广告营销", @"淫秽色情", @"违法反动", @"人身攻击", @"传播谣言"] objectAtIndex:self.selectedIndex];
    newMessage.content = reason;
    
    [newMessage sendWithBlock:^(NSError *error) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"发送成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = nil;
    
    if (self.selectedIndex != -1) {
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedIndex = indexPath.row;
}

@end
