//
//  CC98FaceIconPageView.m
//  CC98Lite
//
//  Created by S on 15/6/14.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98FaceIconPageView.h"
#import "SCGIFImageView.h"

@implementation CC98FaceIconPageView

static const CGFloat faceIconSize = 40.0f;
static const CGFloat faceIconDist = 20.0f;

+ (NSInteger)faceIconNumberPerRow:(CGRect)viewFrame {
    return ((NSInteger)CGRectGetWidth(viewFrame))/((NSInteger)(faceIconSize+faceIconDist));
}

+ (NSInteger)faceIconRowNumber:(CGRect)viewFrame {
    return ((NSInteger)CGRectGetHeight(viewFrame))/((NSInteger)(faceIconSize+faceIconDist));
}

+ (NSInteger)faceIconNumberPerPage:(CGRect)viewFrame {
    return [CC98FaceIconPageView faceIconNumberPerRow:viewFrame] * [CC98FaceIconPageView faceIconRowNumber:viewFrame];
}

- (void)setupUserInterfaceInPage:(NSInteger)pageNum {
    
    CGFloat faceIconNumberPerRow = [CC98FaceIconPageView faceIconNumberPerRow:self.bounds];
    CGFloat faceIconRowNumber = [CC98FaceIconPageView faceIconRowNumber:self.bounds];
    CGFloat faceIconNumberPerPage = [CC98FaceIconPageView faceIconNumberPerPage:self.bounds];
    
    CGFloat faceIconHDist = CGRectGetWidth(self.bounds)/faceIconNumberPerRow-faceIconSize;
    CGFloat faceIconVDist = CGRectGetHeight(self.bounds)/faceIconRowNumber-faceIconSize;
    
    for (NSInteger i=0; i<faceIconRowNumber; ++i) {
        for (NSInteger j=0; j<faceIconNumberPerRow; ++j) {
            UIButton *faceIconButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [self addSubview:faceIconButton];
            CGRect iconFrame = CGRectMake(faceIconHDist/2+j*(faceIconSize+faceIconHDist),
                                          faceIconVDist/2+i*(faceIconSize+faceIconVDist),
                                          faceIconSize, faceIconSize);
            faceIconButton.frame = iconFrame;
            
            NSInteger faceIconNumber = pageNum*faceIconNumberPerPage+i*faceIconNumberPerRow+j;
            faceIconButton.tag = faceIconNumber;
            
            NSString *gifIconName = [NSString stringWithFormat:@"face/emot%02ld", (long)faceIconNumber];
            NSString *gifFilePath = [[NSBundle mainBundle] pathForResource:gifIconName ofType:@"gif"];
            NSData *gifFileData = [[NSData alloc] initWithContentsOfFile:gifFilePath];
            
            SCGIFImageView *gifView = [[SCGIFImageView alloc] initWithGIFData:gifFileData];
            [gifView setFrame:CGRectMake(0, 0, faceIconSize, faceIconSize)];
            gifView.userInteractionEnabled = NO;
            [faceIconButton addSubview:gifView];
            
            [faceIconButton addTarget:self
                               action:@selector(faceClick:)
                     forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)faceClick:(UIButton *)button{
    NSString *faceIconString = [NSString stringWithFormat:@"[em%02ld]", (long)(button.tag)];
    
    if (self.delegate) {
        [self.delegate didSelectFaceIconWithString:faceIconString];
    }
}

- (instancetype)initWithFrame:(CGRect)frame forPageNum:(NSInteger)pageNum {
    if (self = [super initWithFrame:frame]) {
        [self setupUserInterfaceInPage:pageNum];
    }
    return self;
}

@end
