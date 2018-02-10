//
//  ViewController.m
//  HomePodPOC
//
//  Created by Qingchuan Zhu on 2/9/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *toggleSiwtcher;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)refreshToggle{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.qingchuan.HomePodPOC"];
    BOOL toggleOn = [defaults boolForKey:@"enable_touchID"];
    if (toggleOn) {
        [self.toggleSiwtcher setOn:YES];
    } else {
        [self.toggleSiwtcher setOn:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enable_touchID:(UISwitch *)sender {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.qingchuan.HomePodPOC"];
    if (sender.isOn) {
        [defaults setBool:YES forKey:@"enable_touchID"];
    } else {
        [defaults setBool:NO forKey:@"enable_touchID"];
    }
}

@end
