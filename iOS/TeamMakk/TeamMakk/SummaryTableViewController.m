//
//  SummaryTableTableViewController.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "SummaryTableViewController.h"
#import "ExerciseCell.h"
#import <HealthKit/HealthKit.h>

#define kSummaryTableViewCell    @"kSummaryTableViewCell"

@interface SummaryTableViewController () {
  NSArray *_exercises;
}

@end

@implementation SummaryTableViewController

-(void) viewWillAppear:(BOOL)animated
{
  [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  //self.edgesForExtendedLayout = UIRectEdgeAll;
  //self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
  //CGRect frame = self.view.frame;
  //frame.size.height = self.tableView.frame.size.height - self.tabBarController.tabBar.frame.size.height;
  //self.view.frame = frame;
  
  self.navigationController.navigationBar.topItem.title = @"Summary";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSummaryTableViewCell];
    _exercises = [[NSArray alloc] initWithObjects:@"Push Ups", @"Right Plank", @"Left Planks", @"Situps", nil];
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
  headerView.backgroundColor = [UIColor clearColor];
  //self.tableView.tableHeaderView = headerView;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
//  if ([HKHealthStore isHealthDataAvailable]) {
//    self.healthStore = [[HKHealthStore alloc] init];
//    
//    NSSet *writeDataTypes = [self dataTypesToWrite];
//    NSSet *readDataTypes = [self dataTypesToRead];
//    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
//      if (!success) {
//        NSLog(@"You didn't allow healthkit to access these read/write data types");
//        return;
//      }
//      dispatch_async(dispatch_get_main_queue(), ^{
//        [self saveleftPlankTime:60 rightPlankTime:18];
////        [self savePushupTime:30];
////        [self saveCrunchesTime:40];
//        // self update info from healthkit.
//      });
//    }];
//    
//  }
//
//  [self.tableView setNeedsLayout];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  UIEdgeInsets inset = UIEdgeInsetsMake(60, 0, 0, 0);
  self.tableView.contentInset = inset;
  
   self.title = @"Summary";
  [self setTitle:@"Summary"];
  
  
   self.navigationController.title = @"Summary";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   ExerciseCell *cell = [[ExerciseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSummaryTableViewCell exercise:[_exercises objectAtIndex:indexPath.row] exerciseNum:(int)indexPath.row];
  CGRect frame = CGRectMake(5, 5, self.tableView.frame.size.width - 10, (self.tableView.frame.size.height)/3.0 - 5);
  cell.frame = frame;
  cell.exerciseIndex = (int)indexPath.row;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  [cell layoutCellComponents];
    
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return self.view.frame.size.height / 3;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
