//
//  CC98BlockListTableViewCell.h
//  CC98Lite
//
//  Created by S on 15/6/2.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98BlockDataDelegate.h"

@interface CC98BlockListTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CC98BlockDataDelegate> blockData;

@end
