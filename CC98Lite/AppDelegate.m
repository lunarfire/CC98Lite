//
//  AppDelegate.m
//  CC98Lite
//
//  Created by S on 15/5/24.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "AppDelegate.h"
#import "CC98Forum.h"
#import "CC98Client.h"
#import "CC98Account.h"
#import "NSError+CC98Style.h"
#import "CC98PersonalPartition.h"
#import "CC98LoginViewController.h"
#import "CC98PartitionListDataSource.h"
#import "CC98PersonalBoardListDataSource.h"
#import "CC98BlockListTableViewController.h"
#import "CC98ControlPanelDataSource.h"
#import "CC98HotTopicListDataSource.h"
#import "Reachability.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSMutableArray *viewControllers;

@property (nonatomic) Reachability *hostReachability;

@end

@implementation AppDelegate

static const NSUInteger PERSONAL_BOARDS_INDEX_IN_TAB_BAR = 0;

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray arrayWithCapacity:4];
    }
    return _viewControllers;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

    [self insertPartitionListInTabBar];
    [self insertHotTopicListInTabBar];
    [self insertControlPanelInTabBar];
    
    [self checkNetworkStatus];
    return YES;
}

- (void)showInfoDialog:(NSString *)info {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain]
                                                    message:info
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showReachabilityDialog {
    switch (self.hostReachability.currentReachabilityStatus) {
        case NotReachable:  // 目前只在网络不可用时进行提示
            [self showInfoDialog:@"当前网络不可用，请检查网络连接"];
            break;
        default:
            break;
    }
    
    /*
    switch (self.hostReachability.currentReachabilityStatus) {
        case NotReachable:
            [self showInfoDialog:@"无法访问CC98"];
            break;
        case ReachableViaWWAN:
            [self showInfoDialog:@"您正在使用蜂窝网络访问CC98"];
            break;
        case ReachableViaWiFi:
            // [self showInfoDialog:@"您正在使用Wifi访问CC98"];
            break;
        default:
            break;
    }
    */
}

- (void)subscribeNetworkingNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.hostReachability startNotifier];
}

- (void)setNetworkingTimeoutInterval:(NSTimeInterval)timeout {
    [[[CC98Client sharedInstance] requestSerializer] willChangeValueForKey:@"timeoutInterval"];
    [[[CC98Client sharedInstance] requestSerializer] setTimeoutInterval:timeout];
    [[[CC98Client sharedInstance] requestSerializer] didChangeValueForKey:@"timeoutInterval"];
}

- (void)checkNetworkStatus {
    self.hostReachability = [Reachability reachabilityForInternetConnection];
    
    if (self.hostReachability.currentReachabilityStatus == NotReachable) {
        [self showReachabilityDialog];
    } else {
        CC98Account *account = [[CC98Client sharedInstance] currentAccount];
        if (account == nil) {
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            tabBarController.selectedIndex = 2;
        } else {
            [account loginWithBlock:nil];
        }
    }
    
    // 订阅网络状态变化的通知
    [self subscribeNetworkingNotification];

    /*
    self.hostReachability = [Reachability reachabilityWithHostName:address];
    
    if (self.hostReachability.currentReachabilityStatus == NotReachable) {
        [self subscribeNetworkingNotification];
        return;
    }
    
    NSTimeInterval defaultTimeoutInterval = [[[CC98Client sharedInstance] requestSerializer] timeoutInterval];
    [self setNetworkingTimeoutInterval:5.0f];
    
    __weak __typeof(self) weakSelf = self;
    
    [[CC98Client sharedInstance] GET:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf setNetworkingTimeoutInterval:defaultTimeoutInterval];
        [weakSelf subscribeNetworkingNotification];
        
        CC98Account *account = [[CC98Client sharedInstance] currentAccount];
        [account loginWithBlock:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [CC98Client useProxy];
        [[CC98Client sharedInstance] GET:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            weakSelf.hostReachability = [Reachability reachabilityWithHostName:[CC98Client proxyAddressString]];
            [weakSelf subscribeNetworkingNotification];
            [weakSelf setNetworkingTimeoutInterval:defaultTimeoutInterval];
            
            CC98Account *account = [[CC98Client sharedInstance] currentAccount];
            [account loginWithBlock:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [CC98Client useCampusNet];
            [weakSelf subscribeNetworkingNotification];
            [weakSelf setNetworkingTimeoutInterval:defaultTimeoutInterval];
        }];
    }];
    */
}

- (void)reachabilityChanged:(NSNotification *)note
{    
    [self showReachabilityDialog];
}

- (void)insertHotTopicListInTabBar{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navForTableView"];
    
    CC98BlockListTableViewController *viewController = (CC98BlockListTableViewController *)[navController topViewController];
    viewController.title = @"热门话题";
    viewController.tabBarItem.image = [UIImage imageNamed:@"hot"];
    
    viewController.dataSource = [[CC98HotTopicListDataSource alloc] init];
    [self.viewControllers addObject:navController];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.viewControllers = self.viewControllers;
}

- (void)insertControlPanelInTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navForTableView"];
    
    CC98BlockListTableViewController *viewController = (CC98BlockListTableViewController *)[navController topViewController];
    viewController.title = @"个人相关";
    viewController.tabBarItem.image = [UIImage imageNamed:@"user"];
    
    viewController.dataSource = [[CC98ControlPanelDataSource alloc] init];
    [self.viewControllers addObject:navController];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.viewControllers = self.viewControllers;
}

- (void)insertPartitionListInTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navForTableView"];
    
    CC98BlockListTableViewController *viewController = (CC98BlockListTableViewController *)[navController topViewController];
    viewController.title = @"所有版面";
    viewController.tabBarItem.image = [UIImage imageNamed:@"boards"];
    
    CC98PartitionListDataSource *plDataSource = [[CC98PartitionListDataSource alloc] init];
    viewController.dataSource = plDataSource;

    [self.viewControllers addObject:navController];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.viewControllers = self.viewControllers;
}

- (void)insertPersonalBoardsInTabBarIfNeeded {
    if (self.viewControllers.count > 0) {
        UIViewController *firstViewController = self.viewControllers[PERSONAL_BOARDS_INDEX_IN_TAB_BAR];
        if ([firstViewController.title isEqualToString:@"我的版面"]) {
            return;
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navForTableView"];
    
    CC98BlockListTableViewController *viewController = (CC98BlockListTableViewController *)[navController topViewController];
    viewController.title = @"我的版面";
    viewController.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    CC98PersonalBoardListDataSource *pbDataSource = [[CC98PersonalBoardListDataSource alloc] init];
    pbDataSource.partition = [CC98Forum sharedInstance].personalPartition;
    viewController.dataSource = pbDataSource;
    
    [self.viewControllers insertObject:navController atIndex:PERSONAL_BOARDS_INDEX_IN_TAB_BAR];

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.viewControllers = self.viewControllers;
    // tabBarController.selectedIndex = 0;
}

- (void)updatePersonalBoardsInTabBar {
    if (self.viewControllers.count > 0) {
        UINavigationController *navController = self.viewControllers[PERSONAL_BOARDS_INDEX_IN_TAB_BAR];
        CC98BlockListTableViewController *firstViewController = (CC98BlockListTableViewController *)[navController topViewController];
        if ([firstViewController.title isEqualToString:@"我的版面"]) {
            [firstViewController reload:nil];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.zju.CC98Lite" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CC98Lite" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CC98Lite.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
