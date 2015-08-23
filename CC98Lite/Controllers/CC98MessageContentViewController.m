//
//  CC98MessageContentViewController.m
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98MessageContentViewController.h"
#import "CC98Topic.h"
#import "CC98BarButtonItem.h"
#import "UIColor+CC98Style.h"
#import "CC98EditMessageViewController.h"
#import "CC98PostListViewController.h"
#import "SystemUtility.h"
#import "NSError+CC98Style.h"
#import "NSString+CC98Style.h"

@interface CC98MessageContentViewController () <CC98BarButtonItemDelegate, UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *messageContent;
@property (weak, nonatomic) IBOutlet UIToolbar *messageToolBar;
@property (weak, nonatomic) IBOutlet CC98BarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet CC98BarButtonItem *replyButton;
@property (weak, nonatomic) IBOutlet CC98BarButtonItem *writeButton;

@end

@implementation CC98MessageContentViewController

- (IBAction)swipeForPrevMessage:(id)sender {
    if (self.message.prevMessageAddress != nil) {
        CC98Message *prevMessage = [[CC98Message alloc] init];
        prevMessage.address = self.message.prevMessageAddress;
        
        [SystemUtility transitionWithType:kCATransitionReveal WithSubtype:kCATransitionFromLeft ForView:self.view];

        [prevMessage contentWithBlock:^(NSError *error) {
            if (!error) {
                self.message = prevMessage;
                [self displayMessageContent];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"没有上一条消息啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)swipeForNextMessage:(id)sender {
    if (self.message.nextMessageAddress != nil) {
        CC98Message *nextMessage = [[CC98Message alloc] init];
        nextMessage.address = self.message.nextMessageAddress;
        
        [SystemUtility transitionWithType:kCATransitionReveal WithSubtype:kCATransitionFromRight ForView:self.view];
        
        [nextMessage contentWithBlock:^(NSError *error) {
            if (!error) {
                self.message = nextMessage;
                [self displayMessageContent];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"没有下一条消息啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    self.messageToolBar.backgroundColor = [UIColor mediumGrey];
    self.messageContent.dataDetectorTypes = UIDataDetectorTypeNone;
    self.messageContent.delegate = self;
    
    self.deleteButton.title = @"删除";
    self.replyButton.title = @"回复";
    self.writeButton.title = @"撰写";
    
    self.deleteButton.delegate = self;
    self.replyButton.delegate = self;
    self.writeButton.delegate = self;
    
    [self loadMessageContent];
}

- (void)loadMessageContent {
    [self.message contentWithBlock:^(NSError *error) {
        if (!error) {
            [self displayMessageContent];
            //self.navigationItem.title = @"短消息";
        }
    }];
}

- (void)displayMessageContent {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"CC98MessageWebPage" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString *htmlText = [NSMutableString stringWithString:htmlCont];
    [htmlText replaceOccurrencesOfString:@"${title}" withString:[NSString showStringSafely:self.message.title] options:0 range:NSMakeRange(0, [htmlText length])];
    [htmlText replaceOccurrencesOfString:@"${author}" withString:[NSString showStringSafely:self.message.person] options:0 range:NSMakeRange(0, [htmlText length])];
    [htmlText replaceOccurrencesOfString:@"${time}" withString:[NSString showStringSafely:self.message.time] options:0 range:NSMakeRange(0, [htmlText length])];
    [htmlText replaceOccurrencesOfString:@"${content}" withString:[NSString showStringSafely:self.message.content] options:0 range:NSMakeRange(0, [htmlText length])];

    [self.messageContent loadHTMLString:htmlText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

- (void)deleteMessage {
    [self.message deleteWithBlock:^(NSError *error) {
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"删除成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSString *tag = [requestString firstMatchRegex:@"dispbbs\\.asp\\?boardID="];
    if (tag) {
        CC98Topic *topic = [[CC98Topic alloc] init];
        topic.boardID = [requestString firstMatchRegex:@"(?<=boardID=)\\d{1,10}(?=&)"];
        topic.identifier = [requestString firstMatchRegex:@"(?<=&ID=)\\d{1,10}(?=&)"];
        NSInteger pageNum = [[requestString firstMatchRegex:@"(?<=&star=)\\d{1,10}"] integerValue];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        CC98PostListViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"postListWebView"];
        
        viewController.topic = topic;
        viewController.jumpFromOtherPages = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.currentPageNum = pageNum;
        
        return NO;
    }

    return YES;
}

- (void)replyMessage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98EditMessageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editMessageViewController"];
    
    viewController.recipient = nil;
    viewController.originalMessage = self.message;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)writeNewMessage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CC98EditMessageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editMessageViewController"];
    
    viewController.recipient = nil;
    viewController.originalMessage = nil;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)clickToolBarButton:(NSString *)buttonText {
    if ([buttonText isEqualToString:self.deleteButton.title]) {
        [self deleteMessage];
    } else if ([buttonText isEqualToString:self.replyButton.title]) {
        [self replyMessage];
    } else if ([buttonText isEqualToString:self.writeButton.title]) {
        [self writeNewMessage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
