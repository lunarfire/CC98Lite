//
//  CC98AboutViewController.m
//  CC98Lite
//
//  Created by S on 15/7/16.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98AboutViewController.h"

@interface CC98AboutViewController ()

@property (weak, nonatomic) IBOutlet UITextView *aboutText;

@end

@implementation CC98AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    
    NSString *content = @"◎ 软件作者：小林 @CC98\n\n◎ 当前版本号：V1.0\n\n◎ 特别感谢以下朋友的帮助：\n•  科洛丝公主 @CC98\n•  Auser @CC98\n•  ytfhqqu @CC98\n•  欧阳 @CC98\n•  DJ @CC98\n\n◎ 软件使用了以下开源库，向开源库作者表示衷心感谢：\n•  AFNetworking\n•  MBProgressHUD\n•  MWPhotoBrowser\n•  SDWebImage\n•  Reachability\n•  STKeychain\n•  RNGridMenu\n•  SCGIFImage\n\n◎ 软件中所有iOS 7 Style图标（Icon）均来源于Subway图标集，授权条款链接：http://creativecommons.org/licenses/by/4.0/";
    
    UIFont *contentFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    contentFont = [contentFont fontWithSize:14];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.1f;
    
    NSDictionary *textAttributes = @{NSFontAttributeName:contentFont,
                                     NSParagraphStyleAttributeName:paragraphStyle};
    self.aboutText.attributedText = [[NSAttributedString alloc] initWithString:content
                                                                    attributes:textAttributes];
}

- (NSString *)name {
    return @"关于";
}

- (NSString *)info {
    return @"";
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"about"];
}

@end
