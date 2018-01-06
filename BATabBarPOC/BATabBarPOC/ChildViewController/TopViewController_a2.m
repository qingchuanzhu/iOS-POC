//
//  TopViewController_a2.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/28/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "TopViewController_a2.h"

@interface TopViewController_a2 ()

@end

@implementation TopViewController_a2

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
    CGSize newSize = [self.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGRect newFrame = self.view.frame;
    newFrame.size = newSize;
    self.view.frame = newFrame;
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
