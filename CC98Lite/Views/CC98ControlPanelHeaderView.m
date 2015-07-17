//
//  CC98ControlPanelHeaderView.m
//  CC98Lite
//
//  Created by S on 15/6/18.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98ControlPanelHeaderView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+CC98Style.h"

@interface CC98ControlPanelHeaderView ()

@property (strong, nonatomic) void (^block)();
@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIButton *accountButton;

@end

@implementation CC98ControlPanelHeaderView

static const CGFloat IMAGE_SIZE = 75.0f;

- (void)loginInterface {
    if (self.block) {
        self.block();
    }
}

- (UIButton *)accountButton {
    if (!_accountButton) {
        _accountButton = [[UIButton alloc] init];
        _accountButton.center = CGPointMake(self.center.x, self.center.y-10);
        _accountButton.bounds = CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE);
        
        _accountButton.layer.cornerRadius = CGRectGetHeight(_accountButton.bounds)/2;
        _accountButton.clipsToBounds = YES;
        [_accountButton addTarget:self action:@selector(loginInterface) forControlEvents:UIControlEventTouchUpInside];
        
        [_accountButton addSubview:self.userImage];
    }
    return _accountButton;
}

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        _userImage.image = nil;
        
        _userImage.layer.borderWidth = 2;
        _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _userImage.layer.cornerRadius = CGRectGetHeight(_userImage.bounds)/2;
        _userImage.clipsToBounds = YES;
    }
    return _userImage;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.bounds = CGRectMake(0, 0, 100, 15);
        _usernameLabel.center = CGPointMake(self.center.x, self.frame.size.height-_usernameLabel.bounds.size.height);

        _usernameLabel.text = @"";
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _usernameLabel;
}

- (void)setupUserInterface {
    [self addSubview:self.accountButton];
    [self addSubview:self.usernameLabel];
}

- (void)updateWithUserName:(NSString *)name andUserImage:(NSString *)imageAddress {
    self.usernameLabel.text = name;
    
    if ([imageAddress isEqualToString:@"user"]) {
        self.userImage.image = [UIImage imageNamed:@"user"];
        self.userImage.backgroundColor = [UIColor lightBlueColor];
    } else {
        NSURL *imageURL = [NSURL URLWithString:imageAddress];
        [self.userImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user"]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame andBlock:(void (^)())block {
    if (self = [super initWithFrame:frame]) {
        [self setupUserInterface];
        self.block = block;
    }
    return self;
}

@end
