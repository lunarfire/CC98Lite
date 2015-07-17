//
//  CC98BoardDataDelegate.h
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BlockDataDelegate.h"

@class CC98Board;


@interface CC98BoardDataDelegate : NSObject <CC98BlockDataDelegate>

@property (strong, nonatomic) CC98Board *board;

@end
