//
//  CC98BarButtonItem.m
//  CC98Lite
//
//  Created by S on 15/6/10.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BarButtonItem.h"
#import "UIColor+CC98Style.h"
#import "UIButton+CC98Style.h"

@interface CC98BarButtonItem ()

@property (strong, nonatomic) UIButton *button;

@end


@implementation CC98BarButtonItem

- (void)setupUserInterface {
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button configCC98Style];
    
    [self.button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    self.customView = self.button;
}

- (void)clickButton {
    if (self.delegate) {
        [self.delegate clickToolBarButton:self.title];
    }
}

- (void)setTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title {
    return [self.button titleForState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [self setupUserInterface];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUserInterface];
    }
    return self;
}


@end
