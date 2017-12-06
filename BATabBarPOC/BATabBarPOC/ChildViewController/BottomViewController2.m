//
//  BottomViewController2.m
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 11/29/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#import "BottomViewController2.h"
#import "BATabBarController.h"
#import "T_CViewController.h"

#define RESUECELL @"cell"

@interface BottomViewController2 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL cellInserted;

@end

@implementation BottomViewController2

@synthesize needVerticalScrolling;
@synthesize verticalScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.needVerticalScrolling = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RESUECELL];
    self.cellInserted = NO;
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
    self.verticalScrollView = self.tableView;
    [self.tabBarDelegate childViewAppearedWithView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger numberOfInsertedRow = 0;
    if (self.cellInserted) {
        numberOfInsertedRow = 1;
    }
    return 25 + numberOfInsertedRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:RESUECELL forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RESUECELL];
    }
    
    NSString *cellText = @"";
    if (indexPath.row == 1 && self.cellInserted) {
        cellText = @"Inserted Cell";
    } else {
        cellText = @"Normal Cell";
    }
    cell.textLabel.text = cellText;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tabBarDelegate scrollViewDidScroll:scrollView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.cellInserted) {
            //remove the cell at row1
            self.cellInserted = NO;
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]  withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        } else {
            //insert the cell at row1
            self.cellInserted = YES;
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        }
    } else {
        
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
