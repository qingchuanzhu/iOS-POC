//
//  BATabBarViewModel.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/4/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BATabBarViewModel : NSObject

@property (nonatomic, assign) BOOL userEnrolled;

+ (instancetype)sharedInstance;
- (instancetype)init __unavailable;
- (void)setUserEnrolled:(BOOL)enrolled;

@end
