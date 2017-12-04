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
#import "TopViewController.h"
#import "BATabBarController_a1.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *pinnedButtonCtl;
@property (nonatomic, assign) BOOL shouldShowPinnedButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pinnedButtonCtl.on = NO;
}

- (IBAction)switchChanged:(UISwitch *)sender {
    if (sender.on) {
        self.shouldShowPinnedButton = YES;
    } else {
        self.shouldShowPinnedButton = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testForNewWay:(id)sender {
    BATabBarController_a1 *tabBar2 = [BATabBarController_a1 new];
    TopViewController *topVC = [TopViewController new];
    BottomViewController1 *vc1 = [BottomViewController1 new];
    BottomViewController2 *vc2 = [BottomViewController2 new];
    vc1.tabBarDelegate = tabBar2;
    vc2.tabBarDelegate = tabBar2;
    tabBar2.topViewController = topVC;
    tabBar2.childViewControllers = @[vc1, vc2];
    tabBar2.showPinnedButton = self.shouldShowPinnedButton;
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
