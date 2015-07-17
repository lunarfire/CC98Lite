//
//  CC98FaceIconPageViewDelegate.h
//  CC98Lite
//
//  Created by S on 15/6/14.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CC98FaceIconPageViewDelegate <NSObject>

@required

- (void)didSelectFaceIconWithString:(NSString *)faceIconString;

@end
