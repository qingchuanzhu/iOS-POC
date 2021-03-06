//
//  BATabBarController_a1.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/2/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BATabBarController_a2.h"
#import "BATabBarViewModel.h"
#import "BottomSettingsViewController.h"

@interface BATabBarController_a2 ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *childViewHolder;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITabBar *middleTabBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleTabBarBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *pinnedButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childHolderBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *childHolderToPinnedButtonConstraint;

@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, assign) CGFloat topTileHeight; // topView's height - tabBarheight

@property (nonatomic, strong) NSMutableArray<UITabBarItem *> *tabBarItems;
@property (nonatomic, strong) UIScrollView *targetedScrollView;

@property (nonatomic, strong) BATabBarViewModel *viewModel;
@property (nonatomic, strong) UIViewController *settingsViewController;

@end

@implementation BATabBarController_a2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarItems = [NSMutableArray arrayWithArray:self.middleTabBar.items];
    self.middleTabBar.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.viewModel = [BATabBarViewModel sharedInstance];
    self.childHolderToPinnedButtonConstraint = [NSLayoutConstraint constraintWithItem:self.childViewHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pinnedButtonView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarHeight = CGRectGetHeight(self.middleTabBar.frame);
    if (self.topViewController.parentViewController == self) {
        // If already added top VC, won't added it again.
    } else {
        /*topViewController's view will appear needs to be called first in order to provide correct contentSize. The correct height of topView will be used to adjust the constraints of this tab Bar's child view*/
        [self.topViewController beginAppearanceTransition:YES animated:animated];
        [self setTopViewFromVC:self.topViewController];
    }
    
    if (_selectedController != nil) {
        [self setSelectedController:_selectedController];
    } else {
        [self setSelectedController:self.childViewControllers[0]];
    }
    
    self.topTileHeight = self.topViewHeightConstraint.constant - self.tabBarHeight;
    if (self.showPinnedButton) {
        self.pinnedButtonView.hidden = NO;
        // adjust constraints
        self.childHolderBottomConstraint.active = NO;
        self.childHolderToPinnedButtonConstraint.active = YES;
    } else {
        self.pinnedButtonView.hidden = YES;
        self.childHolderBottomConstraint.active = YES;
        self.childHolderToPinnedButtonConstraint.active = NO;
    }
    if (self.viewModel.userEnrolled) {
        [self addSettinsTabBarItem];
    } else {
        [self removeSettinsTabBarItem];
    }
}

- (void)addSettinsTabBarItem{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    [self.tabBarItems insertObject:item atIndex:1];
    [self.middleTabBar setItems:self.tabBarItems];
    BottomSettingsViewController *settingsVC = [BottomSettingsViewController new];
    [self.childViewControllers insertObject:settingsVC atIndex:1];
}

- (void)removeSettinsTabBarItem{
    if (self.tabBarItems[1].tag == 1) {
        [self.tabBarItems removeObjectAtIndex:1];
        [self.middleTabBar setItems:self.tabBarItems];
        [self.childViewControllers removeObjectAtIndex:1];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger selectedIndex = [self.tabBarItems indexOfObject:item];
    UIViewController<BARRTabBarChildProtocol> *selectedVC = self.childViewControllers[selectedIndex];
    if (selectedVC == _selectedController) {
        // same tab will do nothing
    } else {
        [self setSelectedController:selectedVC];
    }
}

- (void)setTopViewFromVC:(UIViewController *)topViewController{
    // no view controller will be conflict with this, so no need to remove any VC.
    [self addChildViewController:topViewController];
    [self addTopView:topViewController.view];
    [topViewController didMoveToParentViewController:self];
}

- (void)setSelectedController:(UIViewController<BARRTabBarChildProtocol> *)selectedController{
    // remove the selected vc, save some memory at least, actually no need to remove
    UIViewController *controllerToRemove = _selectedController;
    [controllerToRemove removeFromParentViewController];
    [controllerToRemove.view removeFromSuperview];
    [controllerToRemove willMoveToParentViewController:nil];
    // add the to-be vc, to-be vc can be the same one as selected vc
    _selectedController = selectedController;
    [self addChildViewController:selectedController];
    NSUInteger selectedIndex = [self.childViewControllers indexOfObject:selectedController];
    [self.middleTabBar setSelectedItem:self.tabBarItems[selectedIndex]];
    [self addChildView:selectedController.view];
    [selectedController didMoveToParentViewController:self];
}

- (void)childViewAppearedWithView{
    UIScrollView *targetView;
    if (_selectedController.verticalScrollView != nil) {
        targetView = _selectedController.verticalScrollView;
    }
    if (targetView != nil) {
        self.targetedScrollView = targetView;
        // we need to dynamically adjust content off set when user lands on the tab, since tab bar may be moved before in another tab
        CGFloat adjustedContentOffset = -(self.topViewHeightConstraint.constant - self.topViewTopConstraint.constant);
        self.targetedScrollView.contentOffset = CGPointMake(0, adjustedContentOffset);
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
    NSLayoutConstraint *top;
    if (_selectedController.needVerticalScrolling) {
        top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    } else {
        top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.topViewHeightConstraint.constant];
    }
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.childViewHolder attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.childViewHolder addConstraints:@[leading, trailing, top, bottom]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.targetedScrollView == scrollView) {
        CGPoint currentOffset = scrollView.contentOffset;
        CGFloat yPosition = currentOffset.y;
        if (yPosition > -self.topViewHeightConstraint.constant) {
            // move top view up by y points
            CGFloat topViewDiff = yPosition + self.topViewHeightConstraint.constant;
            if (topViewDiff >= self.topTileHeight) {
                // pin the whole topView
                self.topViewTopConstraint.constant = self.topTileHeight;
            } else {
                self.topViewTopConstraint.constant = topViewDiff;
            }
        } else {
            self.topViewTopConstraint.constant = 0;
        }
    }
}
@end
