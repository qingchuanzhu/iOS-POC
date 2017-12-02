//
//  BottomViewController1.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/29/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATabBarController_a1.h"

@interface BottomViewController1 : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIViewController<BATabBarControllera1Delegate> *tabBarDelegate;

@end
