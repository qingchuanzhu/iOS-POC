//
//  BATabBarViewModel.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/4/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BATabBarViewModel.h"

@interface BATabBarViewModel()

@end

@implementation BATabBarViewModel

+ (instancetype)sharedInstance{
    static BATabBarViewModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [BATabBarViewModel new];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.userEnrolled = NO;
    }
    return self;
}

- (void)setUserEnrolled:(BOOL)enrolled{
    _userEnrolled = enrolled;
}

@end
