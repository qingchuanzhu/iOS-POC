//
//  BATabBarController.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/28/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BATabBarController.h"

static int contextOfMainScrollView;
static int contextOfTargetScrollView;

@interface BATabBarController ()<UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITabBar *middleTabBar;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *holderView;

@property (nonatomic, strong) UIScrollView *targetedScrollView;
@property (nonatomic, strong) NSArray<UITabBarItem *> *tabBarItems;

@property (nonatomic, assign) CGFloat bottomHeightThreshold;
@property (nonatomic, assign) CGFloat topViewHeight; // the height of view above the tab bar
@property (nonatomic, assign) CGFloat tabBarHeight; // middle tab Bar height
@property (nonatomic, assign) CGFloat bottomViewHeightRef; // the initial bottom view's height
@property (nonatomic, assign) CGFloat extraScrollingSpace; // the maximum additional vertical scrolling space for the mainScrollView
@property (nonatomic, assign) BOOL extraScrollingSpaceEnough; // Is extraScrollingSpace enough for scroll view in child VC if one has it as sub view?

@property (nonatomic, assign) BOOL tabBarPinned;
@property (nonatomic, assign) BOOL tabBarUnPinned;

@end

@implementation BATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarPinned = NO;
    self.tabBarUnPinned = YES;
    self.mainScrollView.alwaysBounceVertical = YES;
    self.extraScrollingSpaceEnough = NO;
    self.tabBarItems = self.middleTabBar.items;
    self.middleTabBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mainScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topViewHeight = self.topViewHeightConstraint.constant;
    self.tabBarHeight = CGRectGetHeight(self.middleTabBar.frame);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.bottomViewHeightConstraint.constant = screenHeight - self.topViewHeight - self.tabBarHeight - navBarHeight - statusBarHeight;
    self.bottomViewHeightRef = self.bottomViewHeightConstraint.constant;
    self.extraScrollingSpace = self.topViewHeight;
    [self setSelectedController:self.childViewControllers[0]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger selectedIndex = [self.tabBarItems indexOfObject:item];
    UIViewController *selectedVC = self.childViewControllers[selectedIndex];
    [self setSelectedController:selectedVC];
}

- (void)setSelectedController:(UIViewController *)selectedController{
    [self addChildViewController:selectedController];
    NSUInteger selectedIndex = [self.childViewControllers indexOfObject:selectedController];
    [self.middleTabBar setSelectedItem:self.tabBarItems[selectedIndex]];
    [self addChildView:selectedController.view];
    [selectedController didMoveToParentViewController:self];
    _selectedController = selectedController;
}

- (void)childViewAppearedWithView:(UIView *)view{
    /*
     direct pinned to bottom view
     if view is kind of scroll view
        disable scroll view's scrolling
        contentSize = compute scroll view content size
        diff = contentSize.height - bottomViewHeightRef
        if diff < 0
            do nothing
        else if diff < extraScrollingSpace
            mainScrollView.contentInset.bottom = extraScrollingSpace - diff
            adjust bottom view height as mainScroll view scrolls
        else
            mainScrollView.contentInset.bottom = extraScrollingSpace
            adjust bottom view height as mainScroll view scrolls, but to the limit when tab Bar pinned to top,
            as soon as tab Bar pinned, make scroll view scroll enabled.
     */
    UIScrollView *targetView = [self seekScrollViewFromView:view];
    if (targetView != nil) {
        self.targetedScrollView = targetView;
        [self.targetedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:&contextOfTargetScrollView];
        targetView.scrollEnabled = NO;
        CGSize targetViewContentSize = targetView.contentSize;
        CGFloat diff = targetViewContentSize.height - self.bottomViewHeightRef;
        if (diff < 0) {
            // do nothing
        } else if (diff < self.extraScrollingSpace){
            self.bottomViewHeightConstraint.constant = self.bottomViewHeightRef + diff;
            self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bottomView.frame), self.bottomView.frame.origin.y + self.bottomViewHeightConstraint.constant);
            self.extraScrollingSpaceEnough = YES;
        } else {
            self.bottomViewHeightConstraint.constant = self.bottomViewHeightRef + self.extraScrollingSpace;
            self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bottomView.frame), self.bottomView.frame.origin.y + self.bottomViewHeightConstraint.constant);
            self.extraScrollingSpaceEnough = NO;
        }
    } else {
        self.targetedScrollView = nil;
        self.extraScrollingSpaceEnough = YES;
    }
}

- (void)addChildView:(UIView *)view{
    [self.bottomView addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    // set constraints
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.bottomView addConstraints:@[leading, trailing, top, bottom]];
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:&contextOfMainScrollView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGPoint contentOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    if (contentOffset.y > self.topViewHeight && self.tabBarPinned == NO) {
        self.tabBarPinned = YES;
        self.tabBarUnPinned = NO;
        // remove tab bar from scrollview
        [self.middleTabBar removeFromSuperview];
        // remove all constraints of tab bar
        [self.middleTabBar removeConstraints:self.middleTabBar.constraints];
        // add tab bar to self.view
        [self.view addSubview:self.middleTabBar];
        // add new constraints to pinned tab bar
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.tabBarHeight];
        [self.view addConstraints:@[leading, trailing, top, height]];
        [self.view setNeedsLayout];
        
        // enable scrolling if we have targeted scroll view and extraScrollingSpaceEnough == NO
        if (self.targetedScrollView != nil && self.extraScrollingSpaceEnough == NO) {
            self.targetedScrollView.scrollEnabled = YES;
            self.mainScrollView.scrollEnabled = NO;
        }
        
    } else if(contentOffset.y < self.topViewHeight && self.tabBarPinned == YES){
        self.tabBarUnPinned = YES;
        self.tabBarPinned = NO;
        // remove tab bar from self.view
        [self.middleTabBar removeFromSuperview];
        // remove all constraints of tab bar
        [self.middleTabBar removeConstraints:self.middleTabBar.constraints];
        // add tab bar to self.view
        [self.holderView addSubview:self.middleTabBar];
        // add new constraints to pinned tab bar
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.holderView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.holderView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.holderView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:self.topViewHeight];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.tabBarHeight];
        [self.holderView addConstraints:@[leading, trailing, top, height]];
        [self.holderView setNeedsLayout];
    }
}

- (void)handleContentOffsetOfMainScrollView:(CGPoint)contentOffset{
    
}

- (void)handleContentOffsetOfTargetedScrollView:(CGPoint)contentOffset{
    
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
