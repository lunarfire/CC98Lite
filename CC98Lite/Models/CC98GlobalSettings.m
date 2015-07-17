//
//  CC98GlobalSettings.m
//  CC98Lite
//
//  Created by S on 15/6/29.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98GlobalSettings.h"

@implementation CC98GlobalSettings

#define IMAGE_DISPLAY_TAG @"enableImageDisplay"

+ (void)setEnableAllImagesDisplay:(BOOL)enableAllImagesDisplay {
    [[NSUserDefaults standardUserDefaults] setBool:enableAllImagesDisplay forKey:IMAGE_DISPLAY_TAG];

}

+ (BOOL)enableAllImagesDisplay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:IMAGE_DISPLAY_TAG];
}

@end
