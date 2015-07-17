//
//  CC98FaceIconMultiplePageView.m
//  CC98Lite
//
//  Created by S on 15/6/14.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98FaceIconMultiplePageView.h"
#import "CC98FaceIconPageView.h"

@interface CC98FaceIconMultiplePageView ()

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation CC98FaceIconMultiplePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static const CGFloat pageControlHeight = 25.0f;
static const NSInteger faceIconTotalNumber = 92;

- (void)setupUserInterface {
    
    CGRect scrollViewRect = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-pageControlHeight);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];

    NSInteger faceIconNumberPerPage = [CC98FaceIconPageView faceIconNumberPerPage:scrollView.frame];
    NSInteger scrollViewPageNum = faceIconTotalNumber/faceIconNumberPerPage+(faceIconTotalNumber%faceIconNumberPerPage>0 ? 1:0);
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*scrollViewPageNum,CGRectGetHeight(scrollView.frame))];
    
    for (int i=0; i<scrollViewPageNum; ++i) {
        CGRect pageViewRect = CGRectMake(i*CGRectGetWidth(scrollView.frame),
                                         0.0f,
                                         CGRectGetWidth(scrollView.frame),
                                         CGRectGetHeight(scrollView.frame));
        CC98FaceIconPageView *faceIconPageView = [[CC98FaceIconPageView alloc] initWithFrame:pageViewRect forPageNum:i];
        [scrollView addSubview:faceIconPageView];
        faceIconPageView.delegate = self;
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.pageControl setFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), CGRectGetWidth(self.bounds), pageControlHeight)];
    [self addSubview:self.pageControl];
    
    [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    self.pageControl.numberOfPages = scrollViewPageNum;
    self.pageControl.currentPage = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (void)didSelectFaceIconWithString:(NSString *)faceIconString {
    if (self.delegate) {
        [self.delegate didSelectFaceIconWithString:faceIconString];
    }
}

@end
