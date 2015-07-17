//
//  CC98BlockDataDelegate.h
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@protocol CC98BlockDataDelegate <NSObject>

@property (readonly, weak) NSString *name;
@property (readonly, weak) NSString *info;
@property (readonly, weak) UIImage *icon;

@end
