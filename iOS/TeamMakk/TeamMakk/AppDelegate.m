//
//  AppDelegate.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GoalsViewController.h"
#import "SummaryTableViewController.h"
#import "WorkoutViewController.h"
#import "DatabaseManager.h"
#import "SummaryTableViewController.h"

@interface AppDelegate () {
  UINavigationController *_navigationController;  // The main navigation controller for the app.
  MainViewController *_mainViewController;     // The main view controller for the app.
  WorkoutViewController *workoutVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Initialize our window.
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // Configure our application.
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
  // Configure our main view controller.
  _mainViewController = [[MainViewController alloc] init];
  [self configureMainViewControllerTabs];
  
  // Attach our main view controller to our navigation controller.
  _navigationController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
  [_navigationController.navigationBar setHidden:NO];
  _navigationController.title = @"TEST";
  
  // Configure our window.
  [self.window setRootViewController:_navigationController];
  [self.window setBackgroundColor:[UIColor whiteColor]];
  [self.window makeKeyAndVisible];
  
  return YES;
}


// Populate the tab bar for our main view controller.
- (void)configureMainViewControllerTabs
{
  // Instantiate our view controllers.
  SummaryTableViewController *summaryVC = [[SummaryTableViewController alloc] init];
  GoalsViewController *goalsVC = [[GoalsViewController alloc] init];
  workoutVC = [[WorkoutViewController alloc] init];
  
  // Configure our tabs.
  NSArray *viewControllers = [[NSArray alloc] initWithObjects: workoutVC, goalsVC, summaryVC, nil];
  NSArray *tabItemTitles = [[NSArray alloc] initWithObjects:@"Workouts", @"Goals", @"Summary", nil];
  
  NSArray *tabItemImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"dumbbell"], [UIImage imageNamed:@"rank"], [UIImage imageNamed:@"diary"],nil];

  // Assign a tab bar item to each view controller.
  for (int i = 0; i < viewControllers.count; i++) {
    UIViewController *viewController = viewControllers[i];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:tabItemTitles[i] image:tabItemImages[i] selectedImage:tabItemImages[i]];
    viewController.tabBarItem = tabBarItem;
  }
  _mainViewController.tabBar.tintColor = [UIColor redColor];
  _mainViewController.viewControllers = viewControllers;
  //UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
  //[window addSubview:navController];
  //_mainViewController.navigationController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

  //Create a timer to poll until the bluetooth works
  [[BluetoothShieldHelper sharedShieldHelper] setListener:workoutVC];
  [self performSelector:@selector(connectBluetooth) withObject:self afterDelay:2.0];
  
  //Try adding data here
  //[[DatabaseManager getSharedInstance] saveExercise:0 numberOfReps:10 date:[NSDate date]];
  
  NSLog(@"Adding activity");
}

-(void) connectBluetooth
{
    [[BluetoothShieldHelper sharedShieldHelper]initDevice];
  
  int currentActivity = [[DatabaseManager getSharedInstance] getCurrentActivityWithWorkoutIndex:0];
  
    NSLog(@"Polled activity");
  NSLog(@"%i", currentActivity);
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
