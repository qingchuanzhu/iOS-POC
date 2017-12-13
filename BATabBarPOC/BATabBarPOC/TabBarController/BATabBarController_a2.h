//
//  BATabBarController_a1.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATabBarProtocolBundle.h"

@protocol BATabBarControllera1Delegate<UIScrollViewDelegate>

- (void)childViewAppearedWithView;

@end

@interface BATabBarController_a1 : UIViewController<BATabBarControllera1Delegate>

@property (nonatomic, strong) NSMutableArray<BARRTabBarChildProtocol> *childViewControllers;
@property (nonatomic, strong) UIViewController<BARRTabBarChildProtocol> *selectedController;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, assign) BOOL showPinnedButton;

@end
