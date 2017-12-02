//
//  BATabBarController_a1.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BATabBarController_a1.h"

@interface BATabBarController_a1 ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *childViewHolder;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITabBar *middleTabBar;

@property (nonatomic, strong) NSArray<UITabBarItem *> *tabBarItems;

@end

@implementation BATabBarController_a1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarItems = self.middleTabBar.items;
    self.middleTabBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setSelectedController:self.childViewControllers[0]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger selectedIndex = [self.tabBarItems indexOfObject:item];
    UIViewController *selectedVC = self.childViewControllers[selectedIndex];
    [self setSelectedController:selectedVC];
}

- (void)setSelectedController:(UIViewController *)selectedController{
    UIViewController *controllerToRemove = _selectedController;
    [controllerToRemove willMoveToParentViewController:nil];
    [self addChildViewController:selectedController];
    NSUInteger selectedIndex = [self.childViewControllers indexOfObject:selectedController];
    [self.middleTabBar setSelectedItem:self.tabBarItems[selectedIndex]];
    [controllerToRemove removeFromParentViewController];
    [controllerToRemove.view removeFromSuperview];
    [self addChildView:selectedController.view];
    [selectedController didMoveToParentViewController:self];
    _selectedController = selectedController;
}

- (void)childViewAppearedWithView:(UIView *)view{
    UIScrollView *targetView = [self seekScrollViewFromView:view];
    if (targetView != nil) {
        
    }
}

- (void)addChildView:(UIView *)view{
    [self.childViewHolder addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    // set constraints
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.childViewHolder addConstraints:@[leading, trailing, top, bottom]];
}

- (UIScrollView *)seekScrollViewFromView:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)view;
    }
    for (UIView *subview in [view subviews]) {
        return [self seekScrollViewFromView:subview];
    }
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
