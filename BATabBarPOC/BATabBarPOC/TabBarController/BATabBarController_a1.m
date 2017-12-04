//
//  BATabBarController_a1.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BATabBarController_a1.h"

@interface BATabBarController_a1 ()<UITabBarDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *childViewHolder;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITabBar *middleTabBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleTabBarBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *pinnedButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childHolderBottomConstraint;

@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, assign) CGFloat topTileHeight; // topView's height - tabBarheight

@property (nonatomic, strong) NSArray<UITabBarItem *> *tabBarItems;
@property (nonatomic, strong) UIScrollView *targetedScrollView;

@end

@implementation BATabBarController_a1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarItems = self.middleTabBar.items;
    self.middleTabBar.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarHeight = CGRectGetHeight(self.middleTabBar.frame);
    if (self.topViewController.parentViewController == self) {
        // If already added top VC, won't added it again.
    } else {
        [self setTopViewFromVC:self.topViewController];
    }
    [self setSelectedController:self.childViewControllers[0]];
    self.topTileHeight = self.topViewHeightConstraint.constant - self.tabBarHeight;
    if (self.showPinnedButton) {
        self.pinnedButtonView.hidden = NO;
        // adjust constraints
        self.childHolderBottomConstraint.constant = CGRectGetHeight(self.pinnedButtonView.frame);
    } else {
        self.pinnedButtonView.hidden = YES;
        self.childHolderBottomConstraint.constant = 0;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger selectedIndex = [self.tabBarItems indexOfObject:item];
    UIViewController *selectedVC = self.childViewControllers[selectedIndex];
    [self setSelectedController:selectedVC];
}

- (void)setTopViewFromVC:(UIViewController *)topViewController{
    // no view controller will be conflict with this, so no need to remove any VC.
    [self addChildViewController:topViewController];
    [self addTopView:topViewController.view];
    [topViewController didMoveToParentViewController:self];
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
        self.targetedScrollView = targetView;
        self.targetedScrollView.delegate = self;
        self.targetedScrollView.contentOffset = CGPointMake(0, -self.topViewHeightConstraint.constant);
        self.targetedScrollView.contentInset = UIEdgeInsetsMake(self.topViewHeightConstraint.constant, 0, 0, 0);
    }
}

- (void)addTopView:(UIView *)view{
    [self.topView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    self.topViewHeightConstraint.constant = CGRectGetHeight(view.frame) + self.tabBarHeight;
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.tabBarHeight];
    [self.topView addConstraints:@[leading, trailing, top, bottom]];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.targetedScrollView == scrollView) {
        CGPoint currentOffset = scrollView.contentOffset;
        CGFloat yPosition = currentOffset.y;
        if (yPosition > -self.topViewHeightConstraint.constant) {
            // move top view up by y points
            self.topViewTopConstraint.constant = yPosition + self.topViewHeightConstraint.constant;
            if (self.topViewTopConstraint.constant > self.topTileHeight) {
                // change middle tab bar bottom constraint to pin it
                CGFloat diff = self.topViewTopConstraint.constant - self.topTileHeight;
                self.middleTabBarBottomConstraint.constant = -diff;
            } else {
                // unpin the middle tab bar
                self.middleTabBarBottomConstraint.constant = 0;
            }
        } else {
            self.topViewTopConstraint.constant = 0;
        }
    }
}

@end
