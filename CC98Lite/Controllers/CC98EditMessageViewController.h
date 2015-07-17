//
//  CC98EditMessageViewController.h
//  CC98Lite
//
//  Created by S on 15/6/22.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CC98Message.h"

@interface CC98EditMessageViewController : UIViewController

@property (strong, nonatomic) CC98Message *originalMessage;
@property (strong, nonatomic) NSString *recipient;

@end
