//
//  TopViewController.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/29/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - (16 + 50 + 33 + 20);
    self.subTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 32;
    CGSize newSize = [self.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:newSize.height]];
//    [self.view setNeedsUpdateConstraints];
    CGRect newFrame = self.view.frame;
    newFrame.size = newSize;
    self.view.frame = newFrame;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
