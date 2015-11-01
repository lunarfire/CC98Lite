//
//  CC98MessageListTableViewController.m
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98MessageListTableViewController.h"
#import "CC98Message.h"
#import "SystemUtility.h"
#import "CC98MessageListTableViewCell.h"
#import "NSError+CC98Style.h"
#import "UIViewController+BackButtonHandler.h"
#import "CC98MessageContentViewController.h"
#import "CC98EditMessageViewController.h"

@interface CC98MessageListTableViewController ()

@property (strong, nonatomic) NSArray *messages;
@property (assign, nonatomic) NSInteger currentPageNum;

@property (assign, nonatomic) BOOL needScrollToTop;
@property (assign, nonatomic) CC98TurnPageType turnPageType;

@end

@implementation CC98MessageListTableViewController

- (void)swipeForPrevPage:(UISwipeGestureRecognizer *)sender {
    if (self.currentPageNum == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"已经到第一页啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        self.turnPageType = TurnToPrevPage;
        self.needScrollToTop = YES;
        --self.currentPageNum;
    }
}

- (void)swipeForNextPage:(UISwipeGestureRecognizer *)sender {
    if (self.currentPageNum == self.messageBox.numberOfPages) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"已经到最后一页啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        self.turnPageType = TurnToNextPage;
        self.needScrollToTop = YES;
        ++self.currentPageNum;
    }
}

- (NSString *)name {
    return self.messageBox.title;
}

- (NSString *)info {
    return @"";
}

- (UIImage *)icon {
    return self.messageBox.icon;
}

- (void)writeNewMessage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98EditMessageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editMessageViewController"];
    
    viewController.recipient = nil;
    viewController.originalMessage = nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.turnPageType = DonotTurnPage;
    self.needScrollToTop = YES;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView = nil;
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] init];
    tempBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempBarButtonItem;
    
    UIBarButtonItem *newMessageBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(writeNewMessage)];
    self.navigationItem.rightBarButtonItem = newMessageBarButtonItem;
    self.currentPageNum = 1;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeForNextPage:)];
    [leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeForPrevPage:)];
    [rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightSwipe];
}

-(BOOL)navigationShouldPopOnBackButton{
    self.messages = nil;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CC98Message *)messageForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.messages count]) {
        return nil;
    } else {
        return [self.messages objectAtIndex:(NSUInteger)indexPath.row];
    }
}

- (void)updateMessagesInPage:(NSInteger)pageNum {
    [self.messageBox messagesInPage:pageNum withBlock:^(NSArray *messages, NSError *error) {
        if (!error) {
            self.messages = messages;
            [self.tableView reloadData];
            
            if (self.needScrollToTop && [self tableView:self.tableView numberOfRowsInSection:0] > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                self.needScrollToTop = NO;
            }
            self.navigationItem.title = [NSString stringWithFormat:@"%@ (%ld/%ld)", self.messageBox.title, (long)(self.currentPageNum), (long)(self.messageBox.numberOfPages)];
            
            switch (self.turnPageType) {
                case TurnToPrevPage:
                    [SystemUtility transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromLeft ForView:self.view];
                    break;
                case TurnToNextPage:
                    [SystemUtility transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self.view];
                    break;
                default:
                    break;
            }
            self.turnPageType = DonotTurnPage;
        }
    }];
}

- (void)setCurrentPageNum:(NSInteger)pageNum {
    NSAssert(pageNum<=self.messageBox.numberOfPages && pageNum>=1, @"检测到无效页码输入");
    
    if (pageNum == self.currentPageNum) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"已经在当前页面啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        _currentPageNum = pageNum;
        [self updateMessagesInPage:_currentPageNum];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateMessagesInPage:self.currentPageNum];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CC98MessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"
                                                                                            forIndexPath:indexPath];
    // Configure the cell...
    cell.message = [self messageForIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98MessageContentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"messageContentWebView"];
    
    viewController.navigationItem.title = self.messageBox.title;
    viewController.message = [self messageForIndexPath:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}





















@end
