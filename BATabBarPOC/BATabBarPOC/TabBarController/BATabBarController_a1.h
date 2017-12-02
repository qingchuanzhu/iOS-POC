//
//  BATabBarController_a1.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATabBarController_a1 : UIViewController

@property (nonatomic, strong) NSArray *childViewControllers;
@property (nonatomic, strong) UIViewController *selectedController;

- (void)childViewAppearedWithView:(UIView *)view;

@end
