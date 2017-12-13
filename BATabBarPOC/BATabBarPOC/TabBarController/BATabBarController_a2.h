//
//  BATabBarController_a1.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATabBarProtocolBundle.h"
#import "BATabBarController_a1.h"

@interface BATabBarController_a2 : UIViewController<BATabBarControllera1Delegate>

@property (nonatomic, strong) NSMutableArray<BARRTabBarChildProtocol> *childViewControllers;
@property (nonatomic, strong) UIViewController<BARRTabBarChildProtocol> *selectedController;
@property (nonatomic, strong) UIViewController *topViewController;
@property (nonatomic, assign) BOOL showPinnedButton;

@end
