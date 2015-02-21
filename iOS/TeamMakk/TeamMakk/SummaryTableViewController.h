//
//  SummaryTableTableViewController.h
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKHealthStore;

@interface SummaryTableViewController : UITableViewController
@property (nonatomic) HKHealthStore *healthStore;
@end
