//
//  CC98PostListViewController.m
//  CC98Lite
//
//  Created by S on 15/6/9.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98PostListViewController.h"
#import "CC98PageOperatingVCDelegate.h"
#import "SystemUtility.h"
#import "CC98Topic.h"
#import "CC98Account.h"
#import "CC98QuotePost.h"
#import "CC98ReplyPost.h"
#import "NSError+CC98Style.h"
#import "UIColor+CC98Style.h"
#import "NSString+CC98Style.h"
#import "CC98BarButtonItem.h"
#import "CC98PageOperatingViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "UIViewController+BackButtonHandler.h"
#import "CC98EditPostViewController.h"
#import "CC98EditMessageViewController.h"
#import "CC98UserProfileTableViewController.h"
#import "CC98GlobalSettings.h"
#import "RNGridMenu.h"
#import "CC98User.h"
#import "CC98Client.h"
#import "UIWebView+Clean.h"
#import "MBProgressHUD.h"
#import "MWPhotoBrowser.h"

@interface CC98PostListViewController () <CC98PageOperatingVCDelegate, UIWebViewDelegate, RNGridMenuDelegate, MWPhotoBrowserDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIWebView *postList;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet CC98BarButtonItem *replyButton;
@property (weak, nonatomic) IBOutlet CC98BarButtonItem *turnPageButton;
@property (weak, nonatomic) IBOutlet CC98BarButtonItem *tailPageButton;
@property (strong, nonatomic) CC98PageOperatingViewController *pageOperatingVC;
@property (assign, nonatomic) NSInteger currentFloorNum;
@property (strong, nonatomic) MWPhoto *currentImage;

@end

@implementation CC98PostListViewController

- (IBAction)swipeForNextPage:(UISwipeGestureRecognizer *)sender {
    if (self.currentPageNum == self.topic.numberOfPages) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"已经到最后一页啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        ++self.currentPageNum;
    }
}

- (IBAction)swipeForPrevPage:(UISwipeGestureRecognizer *)sender {
    if (self.currentPageNum == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                        message:@"已经到第一页啦"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        --self.currentPageNum;
    }
}

/*
- (BOOL)navigationShouldPopOnBackButton{
    self.posts = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [self.postList cleanForDealloc];
    self.postList = nil;

    return YES;
}
*/

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    switch (itemIndex) {
        case 0:  // 引用回复
        {
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
                CC98QuotePost *post = [[CC98QuotePost alloc] init];
                post.quotedPost = self.posts[(self.currentFloorNum-1)%10];
                post.topic = self.topic;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                CC98EditPostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editForPostView"];
                
                viewController.post = post;
                viewController.presetContent = [post quotedContent];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
        case 1:  // 站内短信
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            CC98EditMessageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"editMessageViewController"];
            
            CC98Post *post = self.posts[(self.currentFloorNum-1)%10];
            viewController.recipient = post.author.name;
            
            viewController.originalMessage = nil;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 2:  // 个人资料
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            CC98UserProfileTableViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"userProfileTableView"];
            
            CC98Post *post = self.posts[(self.currentFloorNum-1)%10];
            viewController.userName = post.author.name;
            viewController.userPortrait = post.author.portrait;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)showItemListMenu {
    NSArray *options = @[
                         @"引用回复",
                         @"站内短信",
                         @"个人资料"
                         ];
    RNGridMenu *popMenu = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, options.count)]];
    popMenu.delegate = self;
    popMenu.itemFont = [UIFont boldSystemFontOfSize:18];
    popMenu.itemSize = CGSizeMake(150, 55);
    [popMenu showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([CC98GlobalSettings enableAllImagesDisplay]) {
        [self.postList stringByEvaluatingJavaScriptFromString:@"showAllImages();"];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self.postList stringByEvaluatingJavaScriptFromString:@"var e = document.createEvent('MouseEvents');"];
    //[self.postList stringByEvaluatingJavaScriptFromString:@"e.initEvent('click', true, true);"];
    //[self.postList stringByEvaluatingJavaScriptFromString:@"document.getElementById('showAllImages').dispatchEvent(e);"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL =[request URL];
    NSString *requestString = [[request URL] absoluteString];
    
    if (([[requestURL scheme] isEqualToString:@"http"]
         ||[[requestURL scheme] isEqualToString:@"https"]
         ||[[requestURL scheme] isEqualToString:@"mailto"])
        && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        NSRange range = [requestString rangeOfString:@"." options:NSBackwardsSearch];
        NSString *suffix = [requestString substringFromIndex:range.location+1];
        if ([suffix isEqualToString:@"jpg"]
            || [suffix isEqualToString:@"jpeg"]
            || [suffix isEqualToString:@"png"]
            || [suffix isEqualToString:@"gif"]
            || [suffix isEqualToString:@"bmp"]) {
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            self.currentImage = [MWPhoto photoWithURL:[NSURL URLWithString:requestString]];
            [self.navigationController pushViewController:browser animated:YES];
            
            return NO;
        } else {
            return ![[UIApplication sharedApplication] openURL:requestURL];
        }
    } else {
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        if (components.count == 2 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"click"]) {
            self.currentFloorNum = [(NSString *)[components objectAtIndex:1] integerValue];
            [self showItemListMenu];
            
            return NO;
        }
    }
    return YES;
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return self.currentImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.toolBar.backgroundColor = [UIColor mediumGrey];
    self.postList.delegate = self;
    self.postList.dataDetectorTypes = UIDataDetectorTypeNone;
    
    self.replyButton.title = @"回帖";
    self.turnPageButton.title = @"翻页";
    self.tailPageButton.title = @"尾页";
    
    self.replyButton.delegate = self;
    self.turnPageButton.delegate = self;
    self.tailPageButton.delegate = self;
    
    self.pageOperatingVC.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] init];
    tempBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempBarButtonItem;
    
    if (!self.jumpFromOtherPages) {
        self.currentPageNum = 1;
    }
}

@dynamic currentPageNum;

- (void)setCurrentPageNum:(NSInteger)pageNum {
    // NSAssert(pageNum<=self.topic.numberOfPages && pageNum>=1, @"检测到无效页码输入");
    if (self.pageOperatingVC.currentPageNum > 0) { // 处于翻页过程，而不是第一次显示
        if (self.pageOperatingVC.currentPageNum < pageNum) { // 向后翻页
            [SystemUtility transitionWithType:kCATransitionReveal WithSubtype:kCATransitionFromRight ForView:self.view];
        } else if (self.pageOperatingVC.currentPageNum > pageNum) { // 向前翻页
            [SystemUtility transitionWithType:kCATransitionReveal WithSubtype:kCATransitionFromLeft ForView:self.view];
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.pageOperatingVC.currentPageNum = pageNum;
    [self.topic postsInPage:pageNum withBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.posts = posts;
            [self displayPosts];
            self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", (long)(self.currentPageNum), (long)(self.topic.numberOfPages)];
        }
        [hud hide:YES];
    }];
}

- (NSInteger)currentPageNum {
    return self.pageOperatingVC.currentPageNum;
}

- (CC98PageOperatingViewController *)pageOperatingVC {
    if (!_pageOperatingVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _pageOperatingVC = [storyboard instantiateViewControllerWithIdentifier:@"pageOperatingSemiView"];
    }
    return _pageOperatingVC;
}

- (void)reloadContent {
    self.currentPageNum = self.currentPageNum;
}

- (void)clickToolBarButton:(NSString *)buttonText {
    if ([buttonText isEqualToString:self.turnPageButton.title]) {
        [self presentPageOperatingSemiView];
        
    } else if ([buttonText isEqualToString:self.tailPageButton.title]) {
        self.currentPageNum = self.topic.numberOfPages;
        
    } else if ([buttonText isEqualToString:self.replyButton.title]) {
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
            
            CC98ReplyPost *replyPost = [[CC98ReplyPost alloc] init];
            replyPost.topic = self.topic;
            
            viewController.post = replyPost;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)presentPageOperatingSemiView {
    self.pageOperatingVC.numberOfPages = self.topic.numberOfPages;
    
    [self presentSemiViewController:self.pageOperatingVC withOptions:@{
        KNSemiModalOptionKeys.pushParentBack : @(NO),
        KNSemiModalOptionKeys.parentAlpha : @(0.8)
    }];
}

- (void)turnPageToNumber:(NSInteger)pageNum {
    self.currentPageNum = pageNum;
}

- (void)displayPosts {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"CC98PostListWebPage" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSRange frontRange = [htmlCont rangeOfString:@"$foreach$"];
    NSString *htmlFrontPart = [htmlCont substringToIndex:frontRange.location];
    
    NSRange endRrange = [htmlCont rangeOfString:@"$endeach$"];
    NSString *htmlEndPart = [htmlCont substringFromIndex:endRrange.location+endRrange.length];
    
    NSUInteger middleRangeLocation = frontRange.location+frontRange.length;
    NSRange middleRange = NSMakeRange(middleRangeLocation, endRrange.location-middleRangeLocation);
    NSString *htmlMiddlePart = [htmlCont substringWithRange:middleRange];
    
    NSMutableString *finalText = [NSMutableString stringWithString:htmlFrontPart];
    
    for (CC98Post *post in self.posts) {
        NSMutableString *htmlText = [NSMutableString stringWithString:htmlMiddlePart];
        [htmlText replaceOccurrencesOfString:@"${title}" withString:[NSString showStringSafely:post.title] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${author}" withString:[NSString showStringSafely:post.author.name] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${gender}" withString:[NSString showStringSafely:post.author.gender] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${floor}" withString:[NSString showStringSafely:post.floorInfo] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${time}" withString:[NSString showStringSafely:post.postTime] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${avatar}" withString:[NSString showStringSafely:post.author.portrait] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${content}" withString:[NSString showStringSafely:post.content] options:0 range:NSMakeRange(0, [htmlText length])];
        [htmlText replaceOccurrencesOfString:@"${i}" withString:[NSString showStringSafely:post.floorInfo] options:0 range:NSMakeRange(0, [htmlText length])];
        
        [finalText appendString:htmlText];
    }
    
    [finalText appendString:htmlEndPart];
    [self.postList loadHTMLString:finalText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
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
