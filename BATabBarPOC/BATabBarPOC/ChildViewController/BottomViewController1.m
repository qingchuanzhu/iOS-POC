//
//  BottomViewController1.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/29/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BottomViewController1.h"
#import "BATabBarController.h"
#import "T_CViewController.h"

#define RESUECELL @"cell"

@interface BottomViewController1 ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BottomViewController1

@synthesize needVerticalScrolling;
@synthesize verticalScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RESUECELL];
    self.needVerticalScrolling = YES;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 120)];
    tableHeaderView.backgroundColor = [UIColor greenColor];
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.parentViewController isKindOfClass:[BATabBarController class]]) {
        [(BATabBarController *)self.parentViewController childViewAppearedWithView:self.view];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    if (parent) {
        self.verticalScrollView = self.tableView;
        [self.tabBarDelegate childViewAppearedWithView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:RESUECELL forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RESUECELL];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    T_CViewController *vc = [T_CViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tabBarDelegate scrollViewDidScroll:scrollView];
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
