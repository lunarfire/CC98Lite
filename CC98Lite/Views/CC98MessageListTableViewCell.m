//
//  CC98MessageListTableViewCell.m
//  CC98Lite
//
//  Created by S on 15/6/21.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98MessageListTableViewCell.h"
#import "CC98BlockListIconView.h"
#import "CC98Message.h"
#import "UIColor+CC98Style.h"

@interface CC98MessageListTableViewCell ()

@property (weak, nonatomic) IBOutlet CC98BlockListIconView *messageIcon;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messagePerson;
@property (weak, nonatomic) IBOutlet UILabel *messageTime;

@end

@implementation CC98MessageListTableViewCell

- (void)setupUserInterface {
    self.messageIcon.image = [CC98Message icon];
    self.messageIcon.filledColor = [UIColor lightBlueColor];
}

- (void)awakeFromNib {
    // Initialization code
    [self setupUserInterface];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessage:(CC98Message *)message {
    _message = message;
    
    self.messageTitle.text = _message.title;
    self.messagePerson.text = _message.person;
    self.messageTime.text = _message.time;
    
    if ([self.message hasRead]) {
        self.messageIcon.filledColor = [UIColor lightBlueColor];
    } else {
        self.messageIcon.filledColor = [UIColor redColor];
    }
}

@end
