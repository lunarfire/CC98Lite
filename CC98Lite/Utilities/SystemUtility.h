//
//  SystemUtility.h
//  CC98Lite
//
//  Created by S on 15/8/23.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CC98TurnPageType){
    TurnToPrevPage,  // 向前翻页
    TurnToNextPage,  // 向后翻页
    DonotTurnPage,   // 没在翻页
};

@interface SystemUtility : NSObject

+ (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view;

@end
