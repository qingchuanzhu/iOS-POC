//
//  ViewController.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/28/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "ViewController.h"
#import "BATabBarController.h"
#import "BottomViewController1.h"
#import "BottomViewController2.h"
#import "TopViewController.h"
#import "BATabBarController_a1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testForNewWay:(id)sender {
    BATabBarController_a1 *tabBar2 = [BATabBarController_a1 new];
    BottomViewController1 *vc1 = [BottomViewController1 new];
    BottomViewController2 *vc2 = [BottomViewController2 new];
    tabBar2.childViewControllers = @[vc1, vc2];
    [self.navigationController pushViewController:tabBar2 animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue destinationViewController] isKindOfClass:[BATabBarController class]]) {
        BATabBarController *destVC = (BATabBarController *)[segue destinationViewController];
        BottomViewController1 *vc1 = [BottomViewController1 new];
        BottomViewController2 *vc2 = [BottomViewController2 new];
        destVC.childViewControllers = @[vc1, vc2];
    }
}

@end
