//
//  CC98PageOperatingVCDelegate.h
//  CC98Lite
//
//  Created by S on 15/6/11.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CC98PageOperatingVCDelegate <NSObject>

@required

- (void)turnPageToNumber:(NSInteger)pageNum;

@end
