//
//  SummaryViewController.m
//  TeamMakk
//
//  Created by Michael Weingert on 2015-02-22.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "SummaryViewController.h"
#import "SummaryTableViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  SummaryTableViewController * stvc = [[SummaryTableViewController alloc] initWithStyle:UITableViewStylePlain];
  //stvc set
  
  //self.view addSubview:
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
