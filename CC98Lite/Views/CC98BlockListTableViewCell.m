//
//  CC98BlockListTableViewCell.m
//  CC98Lite
//
//  Created by S on 15/6/2.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98BlockListTableViewCell.h"
#import "CC98Board.h"
#import "UILabel+CC98Style.h"
#import "UIColor+CC98Style.h"
#import "CC98BlockListIconView.h"

@interface CC98BlockListTableViewCell ()

@property (weak, nonatomic) IBOutlet CC98BlockListIconView *blockIcon;
@property (weak, nonatomic) IBOutlet UILabel *blockName;
@property (weak, nonatomic) IBOutlet UILabel *blockInfo;

@end

@implementation CC98BlockListTableViewCell

- (void)setBlockNameText:(NSString *)content {
    [self.blockName setLabelText:content
                       withStyle:UIFontTextStyleHeadline
                        andPoint:18
                        andColor:[UIColor blackColor]];
}

- (void)setBlockInfoText:(NSString *)content {
    [self.blockInfo setLabelText:content
                       withStyle:UIFontTextStyleSubheadline
                        andPoint:14
                        andColor:[UIColor grayColor]];
}

- (void)setupUserInterface {
    [self setBlockNameText:@"未知"];
    [self setBlockInfoText:@"未知"];
    
    [self.blockIcon setFilledColor:[UIColor lightBlueColor]];
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

- (void)setBlockData:(id<CC98BlockDataDelegate>)blockData {
    if (_blockData != blockData) {
        _blockData = blockData;
    }
    
    [self setBlockNameText:_blockData.name];
    [self setBlockInfoText:_blockData.info];
    
    self.blockIcon.image = _blockData.icon;
}

@end
