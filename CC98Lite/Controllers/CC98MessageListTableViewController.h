//
//  CC98MessageListTableViewController.h
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98MessageBox.h"
#import "CC98BlockDataDelegate.h"

@interface CC98MessageListTableViewController : UITableViewController <CC98BlockDataDelegate>

@property (strong, nonatomic) id<CC98MessageBox> messageBox;

@end
