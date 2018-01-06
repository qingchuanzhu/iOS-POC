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
#import "TopViewController_a2.h"
#import "BATabBarController_a1.h"
#import "BATabBarController_a2.h"

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
    TopViewController_a2 *topVC = [TopViewController_a2 new];
    BottomViewController1 *vc1 = [BottomViewController1 new];
    BottomViewController2 *vc2 = [BottomViewController2 new];
    vc1.tabBarDelegate = tabBar2;
    vc2.tabBarDelegate = tabBar2;
    tabBar2.topViewController = topVC;
    tabBar2.childViewControllers = (NSMutableArray<BARRTabBarChildProtocol>*)[NSMutableArray arrayWithArray:@[vc1, vc2]];
    tabBar2.showPinnedButton = self.shouldShowPinnedButton;
    [self.navigationController pushViewController:tabBar2 animated:YES];
}

- (IBAction)testForAlpha2Way:(id)sender {
    BATabBarController_a2 *tabBar3 = [BATabBarController_a2 new];
    TopViewController *topVC = [TopViewController new];
    BottomViewController1 *vc1 = [BottomViewController1 new];
    BottomViewController2 *vc2 = [BottomViewController2 new];
    vc1.tabBarDelegate = tabBar3;
    vc2.tabBarDelegate = tabBar3;
    tabBar3.topViewController = topVC;
    tabBar3.childViewControllers = (NSMutableArray<BARRTabBarChildProtocol>*)[NSMutableArray arrayWithArray:@[vc1, vc2]];
    tabBar3.showPinnedButton = self.shouldShowPinnedButton;
    [self.navigationController pushViewController:tabBar3 animated:YES];
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
