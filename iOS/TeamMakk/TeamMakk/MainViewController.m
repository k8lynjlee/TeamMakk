//
//  ViewController.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "MainViewController.h"
//#import <HealthKit/HealthKit.h>

@interface MainViewController () {
}

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
//
//  if ([HKHealthStore isHealthDataAvailable]) {
//    NSSet *writeDataTypes = [self dataTypesToWrite];
//    NSSet *readDataTypes = [self dataTypesToRead];
//    
//    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
//      if (!success) {
//        NSLog(@"You didn't allow healthkit to access these read/write data types");
//        return;
//      }
//      dispatch_async(dispatch_get_main_queue(), ^{
//        // self update labels and stuff
//      });
//    }];
//  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
