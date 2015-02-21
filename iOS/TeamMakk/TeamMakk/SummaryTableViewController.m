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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSummaryTableViewCell];
    _exercises = [[NSArray alloc] initWithObjects:@"Push ups", @"Crunches", @"Side planks", nil];
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
  self.tableView.tableHeaderView = headerView;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  
  
  if ([HKHealthStore isHealthDataAvailable]) {
    self.healthStore = [[HKHealthStore alloc] init];
    
    NSSet *writeDataTypes = [self dataTypesToWrite];
    NSSet *readDataTypes = [self dataTypesToRead];
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"You didn't allow healthkit to access these read/write data types");
        return;
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        [self saveNumberPushups:20 crunches:50 leftPlankTime:60 rightPlankTime:18];
        // self update info from healthkit
      });
    }];
  }
//
//  [self logWorkoutWithDuration:67];
  
  
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)logWorkoutWithDuration:(NSTimeInterval)interval {
  NSMutableArray *samples;
  HKQuantity *energy = [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:interval*3];
  HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeFunctionalStrengthTraining
                                                startDate:[NSDate date]
                                                  endDate:[NSDate date]
                                                 duration:interval
                                        totalEnergyBurned:energy
                                            totalDistance:nil
                                                 metadata:nil];
  [self.healthStore addSamples:samples toWorkout:workout completion:^(BOOL success, NSError *error) {
    
  }];
  
  [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
       if (!success) {
      NSLog(@"An error occured saving the data");
         abort();
       }
     UIAlertView *savealert=[[UIAlertView alloc]initWithTitle:@"SmartMat" message:@"Values has been saved to HealthKit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    NSLog(@"Saved the data");
       [savealert show];
  }];
}

- (void)saveNumberPushups:(double)pushups crunches:(double)crunches leftPlankTime:(double)leftTime rightPlankTime:(double)rightTime {
  HKUnit *repUnit = [HKUnit countUnit];
  HKUnit *plankTime = [HKUnit secondUnit];
  HKUnit *cal = [HKUnit kilocalorieUnit];
  
  float caloriesFromPlank = (leftTime + rightTime)*.2;
  float duration = leftTime + rightTime;
  
  HKQuantity *pushUpsQuantity = [HKQuantity quantityWithUnit:repUnit doubleValue:pushups];
  HKQuantity *crunchesQuantity = [HKQuantity quantityWithUnit:repUnit doubleValue:crunches];
  
  HKQuantity *leftPlankEnergy = [HKQuantity quantityWithUnit:cal doubleValue:leftTime*.5];
  HKQuantity *rightPlankEnergy = [HKQuantity quantityWithUnit:cal doubleValue:rightTime*.5];
  
  HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  HKQuantity *calories = [HKQuantity quantityWithUnit:cal doubleValue:caloriesFromPlank];
  
  HKQuantitySample *leftPlank = [HKQuantitySample quantitySampleWithType:type
                                                                quantity:leftPlankEnergy
                                                               startDate:[NSDate date]
                                                                 endDate:[NSDate date]
                                                                metadata:nil];
  
  HKQuantitySample *rightPlank = [HKQuantitySample quantitySampleWithType:type
                                                                 quantity:rightPlankEnergy
                                                               startDate:[NSDate date]
                                                                 endDate:[NSDate date]
                                                                metadata:nil];
  
  NSMutableArray *samples = [[NSMutableArray alloc] initWithObjects:leftPlank, rightPlank, nil];
  
//  NSArray *objects = [[NSArray alloc] initWithObjects:pushUpsQuantity, crunchesQuantity, leftPlankTime, rightPlankTime, nil];
  

  
  HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeFunctionalStrengthTraining
                                                startDate:[NSDate date]
                                                  endDate:[NSDate date]
                                                 duration:duration
                                        totalEnergyBurned:calories
                                            totalDistance:nil
                                                 metadata:nil];
 
  
  [self.healthStore saveObject:workout withCompletion:^(BOOL success, NSError *error) {
    if (!success) {
      NSLog(@"An error occured saving the data");
      abort();
    }
    
    [self.healthStore addSamples:samples toWorkout:workout completion:^(BOOL success, NSError *error) {
      if (!success) {
        NSLog(@"An error occured adding sample to workout");
        NSLog(@"%@", error.description);
        abort();
      }
      NSLog(@"Added samples to workout");
    }];
    
//    UIAlertView *savealert=[[UIAlertView alloc]initWithTitle:@"SmartMat" message:@"Values has been saved to HealthKit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    NSLog(@"Saved the data");
//    [savealert show];
  }];
  

  
//  [self.healthStore saveObjects:objects withCompletion:^(BOOL success, NSError *error) {
//    if (!success) {
//      NSLog(@"An error occured saving the data");
//      abort();
//    }
//    UIAlertView *savealert=[[UIAlertView alloc]initWithTitle:@"SmartMat" message:@"Values has been saved to HealthKit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [savealert show];
//  }];
}


#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
//  HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
  HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
  HKWorkoutType *workoutType = [HKWorkoutType workoutType];
  
  return [NSSet setWithObjects:workoutType, activeEnergyBurnType, nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
  HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//  HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
  
  return [NSSet setWithObjects:heightType, nil];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   ExerciseCell *cell = [[ExerciseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSummaryTableViewCell exercise:[_exercises objectAtIndex:indexPath.row]];
  CGRect frame = CGRectMake(5, 5, self.tableView.frame.size.width - 10, self.tableView.frame.size.height/3.0 - 5);
  cell.frame = frame;
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
