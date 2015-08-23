//
//  CC98PostListViewController.h
//  CC98Lite
//
//  Created by S on 15/6/9.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98BarButtonItemDelegate.h"

@class CC98Topic;

@interface CC98PostListViewController : UIViewController <CC98BarButtonItemDelegate>

@property (strong, nonatomic) CC98Topic *topic;
@property (assign, nonatomic) NSInteger currentPageNum;
@property (assign, nonatomic) BOOL jumpFromOtherPages;

- (void)clickToolBarButton:(NSString *)buttonText;
- (void)reloadContent;

@end
