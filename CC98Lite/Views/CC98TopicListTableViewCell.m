//
//  CC98TopicListTableViewCell.m
//  CC98Lite
//
//  Created by S on 15/6/3.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98TopicListTableViewCell.h"
#import "CC98BlockListIconView.h"
#import "CC98Topic.h"
#import "CC98ResizeWidthLabel.h"
#import "NSDate+CC98Style.h"
#import "UIColor+CC98Style.h"
#import "UILabel+CC98Style.h"

@interface CC98TopicListTableViewCell ()

@property (weak, nonatomic) IBOutlet CC98BlockListIconView *topicIcon;
@property (weak, nonatomic) IBOutlet CC98ResizeWidthLabel *topicTitle;
@property (weak, nonatomic) IBOutlet CC98BlockListIconView *popularityIcon;
@property (weak, nonatomic) IBOutlet UILabel *popularity;
@property (weak, nonatomic) IBOutlet CC98BlockListIconView *authorIcon;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *latestReplyTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popularityIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popularityIconOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authorIconOffset;

@end

@implementation CC98TopicListTableViewCell

static const CGFloat TOPIC_TITLE_SIZE = 14.5f;
static const CGFloat TOPIC_INFO_SIZE = 10.5f;

- (void)setTopicTitleText:(NSString *)content {
    [self.topicTitle setLabelText:content
                        withStyle:UIFontTextStyleHeadline
                         andPoint:TOPIC_TITLE_SIZE
                         andColor:[UIColor blackColor]];
}

- (void)setReadCount:(NSInteger)readCount andReplyCount:(NSInteger)replyCount {
    [self.popularityIcon setText:@"人气"];
    
    [self.popularity setLabelText:[NSString stringWithFormat:@"%ld/%ld", (long)replyCount, (long)readCount]
                       withStyle:UIFontTextStyleSubheadline
                        andPoint:TOPIC_INFO_SIZE
                        andColor:[UIColor grayColor]];
}

- (void)setAuthorNameText:(NSString *)authorName {
    [self.authorIcon setText:@"作者"];

    [self.authorName setLabelText:authorName
                        withStyle:UIFontTextStyleSubheadline
                         andPoint:TOPIC_INFO_SIZE
                         andColor:[UIColor grayColor]];
}

- (void)setLatestReplyTimeText:(NSString *)time {
    [self.latestReplyTime setLabelText:time
                             withStyle:UIFontTextStyleSubheadline
                              andPoint:TOPIC_INFO_SIZE
                              andColor:[UIColor grayColor]];
}

- (void)setBoardNameText:(NSString *)boardName {
    [self.popularityIcon setText:@"版面"];

    [self.popularity setLabelText:boardName
                             withStyle:UIFontTextStyleSubheadline
                              andPoint:TOPIC_INFO_SIZE
                              andColor:[UIColor grayColor]];
}

- (void)setupUserInterface {
    [self.topicTitle setNumberOfLines:2];
    [self.topicIcon setFilledColor:[UIColor lightBlueColor]];
    
    [self setTopicTitleText:@"未知"];
    [self setAuthorNameText:@"未知"];
    
    [self setLatestReplyTimeText:[[NSDate date] toString]];
    
    static const CGFloat SCREEN_WIDTH_BETWEEN_5S_AND_6 = 350;
    if ([UIScreen mainScreen].bounds.size.width < SCREEN_WIDTH_BETWEEN_5S_AND_6) {
        self.popularityIconWidth.constant = 0;
        self.authorIconWidth.constant = 0;
        self.popularityIconOffset.constant = 0;
        self.authorIconOffset.constant = 0;
    }
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

- (void)setTopic:(CC98Topic *)topic {
    if (_topic != topic) {
        _topic = topic;
    }
    
    [self setTopicTitleText:_topic.title];
    [self setAuthorNameText:_topic.authorName];
    [self setLatestReplyTimeText:_topic.latestReplyTime];
    
    if (_topic.boardName != nil) {
        [self setBoardNameText:_topic.boardName];
    } else {
        [self setReadCount:_topic.numberOfReadTimes andReplyCount:_topic.numberOfReplies];
    }
    
    self.topicIcon.image = [[_topic class] icon];
    self.topicIcon.filledColor = [self topicIconColor:_topic.status];
}

- (UIColor *)topicIconColor:(CC98TopicStatus)status {
    switch (status) {
        case CC98TopestTopic:
            return [UIColor redColor];
        case CC98TopTopic:
            return [UIColor orangeColor];
        case CC98OpenTopic:
            return [UIColor lightBlueColor];
        case CC98SavedTopic:
            return [UIColor lightGreenColor];
        case CC98EssentialTopic:
            return [UIColor blueColor];
        case CC98LockedTopic:
            return [UIColor lightGrayColor];
        default:
            return [UIColor lightBlueColor];
    }
}

@end
