//
//  BATabBarController.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/28/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATabBarController : UIViewController

@property (nonatomic, strong) NSArray *childViewControllers;
@property (nonatomic, strong) UIViewController *selectedController;

@end
