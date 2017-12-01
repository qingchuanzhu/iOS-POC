//
//  BATabBarController.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/28/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BATabBarController.h"

@interface BATabBarController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITabBar *middleTabBar;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (nonatomic, assign) CGFloat topViewHeight; // the height of view above the tab bar
@property (nonatomic, assign) CGFloat tabBarHeight; // middle tab Bar height
@property (nonatomic, assign) CGFloat bottomViewHeightRef; // the initial bottom view's height

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
    CGFloat extraScrollingSpace = self.topViewHeight + self.tabBarHeight;
}

- (void)setSelectedController:(UIViewController *)selectedController{
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
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
    } else if(contentOffset.y < self.topViewHeight && self.tabBarPinned == YES){
        self.tabBarUnPinned = YES;
        self.tabBarPinned = NO;
        // remove tab bar from self.view
        [self.middleTabBar removeFromSuperview];
        // remove all constraints of tab bar
        [self.middleTabBar removeConstraints:self.middleTabBar.constraints];
        // add tab bar to self.view
        [self.mainScrollView addSubview:self.middleTabBar];
        // add new constraints to pinned tab bar
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainScrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainScrollView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainScrollView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:self.topViewHeight];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.tabBarHeight];
        [self.mainScrollView addConstraints:@[leading, trailing, top, height]];
        [self.mainScrollView setNeedsLayout];
    }
    
    // change content size of bottom view
//    CGFloat diffToAdjust = contentOffset.y;
//    self.bottomViewHeightConstraint.constant = self.bottomViewHeightRef + diffToAdjust;
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
