//
//  GoalsTableViewController.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "GoalsViewController.h"
#import "M13ProgressViewRing.h"

#define kGoalsTableViewCell    @"kGoalsTableViewCell"

@interface GoalsViewController ()
{
  UISegmentedControl *_mainSwitcher;
  M13ProgressViewRing *_progressRing;
}

@end

@implementation GoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  _mainSwitcher = [[UISegmentedControl alloc] initWithItems:@[@"Push ups", @"Situps", @"Left Plank", @"Right Plank"]];
  _mainSwitcher.frame = CGRectMake(0, 40, 100, 100);
  [_mainSwitcher sizeToFit];
  [self.view addSubview:_mainSwitcher];
  
  _progressRing = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake(100, 140, 200, 200)];
  [_progressRing setProgress:0.5 animated:YES];
  [self.view addSubview:_progressRing];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
