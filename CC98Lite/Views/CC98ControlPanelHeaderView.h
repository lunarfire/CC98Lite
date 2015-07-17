//
//  CC98ControlPanelHeaderView.h
//  CC98Lite
//
//  Created by S on 15/6/18.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CC98ControlPanelHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame andBlock:(void (^)())block;
- (void)updateWithUserName:(NSString *)name andUserImage:(NSString *)imageAddress;

@end
