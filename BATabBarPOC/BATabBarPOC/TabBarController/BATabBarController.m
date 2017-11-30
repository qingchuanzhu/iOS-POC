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

@property (nonatomic, assign) CGFloat topViewHeight;

@end

@implementation BATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mainScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.topViewHeight = self.topViewHeightConstraint.constant;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGPoint contentOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    if (contentOffset.y > self.topViewHeight) {
        // remove tab bar from scrollview
        [self.middleTabBar removeFromSuperview];
        CGFloat tabBarHeight = CGRectGetHeight(self.middleTabBar.frame);
        // remove all constraints of tab bar
        [self.middleTabBar removeConstraints:self.middleTabBar.constraints];
        // add tab bar to self.view
        [self.view addSubview:self.middleTabBar];
        // add new constraints to pinned tab bar
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:tabBarHeight];
        [self.view addConstraints:@[leading, trailing, top, height]];
        [self.view setNeedsLayout];
    } else if(contentOffset.y < self.topViewHeight){
        // remove tab bar from self.view
        [self.middleTabBar removeFromSuperview];
        CGFloat tabBarHeight = CGRectGetHeight(self.middleTabBar.frame);
        // remove all constraints of tab bar
        [self.middleTabBar removeConstraints:self.middleTabBar.constraints];
        // add tab bar to self.view
        [self.mainScrollView addSubview:self.middleTabBar];
        // add new constraints to pinned tab bar
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mainScrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mainScrollView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mainScrollView attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:self.topViewHeight];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.middleTabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:tabBarHeight];
        [self.mainScrollView addConstraints:@[leading, trailing, top, height]];
        [self.mainScrollView setNeedsLayout];
    }
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
