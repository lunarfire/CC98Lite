//
//  CC98EditPostViewController.h
//  CC98Lite
//
//  Created by S on 15/6/13.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CC98Post;


@interface CC98EditPostViewController : UIViewController

@property (strong, nonatomic) CC98Post *post;
@property (strong, nonatomic) NSString *presetContent;

@end
