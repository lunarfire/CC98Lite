//
//  CC98LoginViewController.m
//  CC98Lite
//
//  Created by S on 15/6/4.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98LoginViewController.h"
#import "CC98Account.h"
#import "CC98Client.h"
#import "UIColor+CC98Style.h"
#import "NSError+CC98Style.h"
#import "NSString+CC98Style.h"
#import "CC98TextFieldIconView.h"
#import "CC98UserInfo.h"
#import "MBProgressHUD.h"
#import "CC98AboutViewController.h"
#import "Header.h"

@interface CC98LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *forumLogo;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *proxy;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIView *usernameLine;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;
@property (weak, nonatomic) IBOutlet UIView *proxyLine;
@property (weak, nonatomic) IBOutlet UIButton *eulaButton;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) CGFloat originalCenterY;

@end

@implementation CC98LoginViewController

- (IBAction)clickForDisplayEULA:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    CC98AboutViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"aboutText"];
    [viewController displayNoticeContent];
    
    UIBarButtonItem *tempBarButtonItem = [[UIBarButtonItem alloc] init];
    tempBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempBarButtonItem;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)clickLogin:(UIButton *)sender {
    CC98Account *account = [[CC98Account alloc] initWithUsername:[self.username text]
                                                     andPassword:[self.password text]];
    
    NSError *checkError = nil;
    [account checkValidWithError:&checkError];
    
    if (checkError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:checkError.domain
                                                        message:checkError.localizedDescription
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.proxy.text != nil && self.proxy.text.length > 0) {
        [CC98Client useProxyWithAddress:self.proxy.text];
    } else {
        [CC98Client useProxyWithAddress:[CC98Client addressString]];
    }
    
    __weak __typeof(self) weakSelf = self;
    [self.hud show:YES];
    
    [account loginWithBlock:^(NSError *loginError) {
        [weakSelf.hud hide:YES];
        
        if (!loginError) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {  // 登录失败时的处理
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:loginError.domain
                                                            message:loginError.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)configCC98Button:(UIButton *)button {
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0f];
    [button.layer setBorderWidth:0.8f];
    [button.layer setBorderColor:[UIColor lightBlueColor].CGColor];
    
    [button setTitleColor:[UIColor lightBlueColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
}

- (void)configCC98TextField:(UITextField *)textField withIconName:(NSString *)iconName {
    static const CGFloat ICON_SCALE_WIDTH = 35.0f;
    static const CGFloat ICON_SCALE_HEIGHT = 22.0f;
    CGFloat y = (self.username.bounds.size.height-ICON_SCALE_HEIGHT)/2;
    
    CGRect iconRect = CGRectMake(0, y, ICON_SCALE_WIDTH, ICON_SCALE_HEIGHT);
    CC98TextFieldIconView *iconView = [[CC98TextFieldIconView alloc] initWithFrame:iconRect];
    iconView.image = [UIImage imageNamed:iconName];
    
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud hide:YES];
    
    [self configCC98Button:self.login];
    [self configCC98TextField:self.username withIconName:@"user"];
    [self configCC98TextField:self.password withIconName:@"password"];
    [self configCC98TextField:self.proxy withIconName:@"setting"];
    
    self.usernameLine.backgroundColor = [UIColor lightBlueColor];
    self.passwordLine.backgroundColor = [UIColor lightBlueColor];
    self.proxyLine.backgroundColor = [UIColor lightBlueColor];
    
    // 该变量用于上移输入框（防止被输入法界面遮挡）后的还原定位
    self.originalCenterY = self.view.center.y;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[self.eulaButton titleForState:UIControlStateNormal]];
    NSRange titleRange = {0, [title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [self.eulaButton setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 键盘弹出或收回时，调用相应函数进行输入框的上移和回移
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak __typeof(self) weakSelf = self;
    
    if (iphone4x_3_5) {
        [UIView animateWithDuration:duration animations:^{
            CGPoint center = weakSelf.view.center;
            center.y = 120;
            weakSelf.view.center = center;
        }];
    } else if (iphone5x_4_0) {
        [UIView animateWithDuration:duration animations:^{
            CGPoint center = weakSelf.view.center;
            center.y = 180;
            weakSelf.view.center = center;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak __typeof(self) weakSelf = self;
    
    if (iphone4x_3_5 || iphone5x_4_0) {
        [UIView animateWithDuration:duration animations:^{
            CGPoint center = weakSelf.view.center;
            center.y = weakSelf.originalCenterY;
            weakSelf.view.center = center;
        }];
    }
}

@end
