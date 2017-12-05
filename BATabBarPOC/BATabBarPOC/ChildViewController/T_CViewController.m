//
//  T&CViewController.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/4/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "T_CViewController.h"
#import "BATabBarViewModel.h"

@interface T_CViewController ()

@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (nonatomic, strong) BATabBarViewModel *viewModel;

@end

@implementation T_CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewModel = [BATabBarViewModel sharedInstance];
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)declineButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
