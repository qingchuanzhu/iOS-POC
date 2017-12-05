//
//  BATabBarController_a1.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATabBarControllera1Delegate<UIScrollViewDelegate>

- (void)childViewAppearedWithView:(UIView *)view;

@end

@interface BATabBarController_a1 : UIViewController<BATabBarControllera1Delegate>

@property (nonatomic, strong) NSMutableArray *childViewControllers;
@property (nonatomic, strong) UIViewController *selectedController;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, assign) BOOL showPinnedButton;

@end
