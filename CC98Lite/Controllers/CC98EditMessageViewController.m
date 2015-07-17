//
//  CC98EditMessageViewController.m
//  CC98Lite
//
//  Created by S on 15/6/22.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98EditMessageViewController.h"

@interface CC98EditMessageViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageRecipient;
@property (weak, nonatomic) IBOutlet UITextField *messageTitle;
@property (weak, nonatomic) IBOutlet UITextView *messageContent;
@property (weak, nonatomic) IBOutlet UILabel *messagePlaceholder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewBottomLocation;


@end

@implementation CC98EditMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageRecipient.delegate = self;
    self.messageTitle.delegate = self;
    self.messagePlaceholder.text = @"短消息内容 ...";
    
    self.messageContent.delegate = self;
    self.messageContent.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.messageContent.layoutManager.allowsNonContiguousLayout = NO;
    [self presetMessage];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    self.messageRecipient.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"收件人 ..."
                                                                              attributes:dict];
    self.messageTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短消息标题 ..."
                                                                           attributes:dict];
    self.navigationItem.title = @"发送短消息";
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelMessage)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIBarButtonItem *proposeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem = proposeButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelMessage {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessage {
    CC98Message *newMessage = [[CC98Message alloc] init];
    
    newMessage.person = self.messageRecipient.text;
    newMessage.title = self.messageTitle.text;
    newMessage.content = self.messageContent.text;
    
    [newMessage sendWithBlock:^(NSError *error) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"发送成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.messageContent scrollRangeToVisible:self.messageContent.selectedRange];
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
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.textviewBottomLocation.constant != keyboardRect.size.height) {
        self.textviewBottomLocation.constant = keyboardRect.size.height;
    }
    
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.textviewBottomLocation.constant = 0;
    
    NSDictionary *userInfo = [notification userInfo];
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)presetMessage {
    if (self.originalMessage != nil) {
        self.messageRecipient.text = self.originalMessage.person;
        self.messageTitle.text = self.originalMessage.repliedTitle;
        
        self.messageContent.text = self.originalMessage.quotedContent;
        self.messageContent.selectedRange = NSMakeRange(self.messageContent.text.length, 0);
        [self textViewDidChange:self.messageContent];
    }
    
    if (self.recipient != nil) {
        self.messageRecipient.text = self.recipient;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.messagePlaceholder.hidden = YES;
    } else {
        self.messagePlaceholder.hidden = NO;
    }
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
