//
//  CC98BarButtonItemDelegate.h
//  CC98Lite
//
//  Created by S on 15/6/10.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CC98BarButtonItemDelegate <NSObject>

@required

- (void)clickToolBarButton:(NSString *)buttonText;

@end
