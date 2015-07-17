//
//  CC98LoginViewController.m
//  CC98Lite
//
//  Created by S on 15/6/4.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98LoginViewController.h"
#import "CC98Account.h"
#import "UIColor+CC98Style.h"
#import "NSError+CC98Style.h"
#import "NSString+CC98Style.h"
#import "CC98TextFieldIconView.h"
#import "CC98UserInfo.h"

@interface CC98LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *forumLogo;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIView *usernameLine;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;

@end

@implementation CC98LoginViewController

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
    
    [account loginWithBlock:^(NSError *loginError) {
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
    static const CGFloat ICON_SCALE_HEIGHT = 26.0f;
    CGFloat y = (self.username.bounds.size.height-ICON_SCALE_HEIGHT)/2;
    
    CGRect iconRect = CGRectMake(0, y, ICON_SCALE_WIDTH, ICON_SCALE_HEIGHT);
    CC98TextFieldIconView *iconView = [[CC98TextFieldIconView alloc] initWithFrame:iconRect];
    iconView.image = [UIImage imageNamed:iconName];
    
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configCC98Button:self.login];
    [self configCC98TextField:self.username withIconName:@"user"];
    [self configCC98TextField:self.password withIconName:@"password"];
    
    self.usernameLine.backgroundColor = [UIColor lightBlueColor];
    self.passwordLine.backgroundColor = [UIColor lightBlueColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
