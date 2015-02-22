//
//  GoalsTableViewController.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "GoalsViewController.h"
#import "M13ProgressViewRing.h"
#import "DatabaseManager.h"
#import "WorkoutGoalObject.h"

#define kGoalsTableViewCell    @"kGoalsTableViewCell"

@interface GoalsViewController ()
{
  UISegmentedControl *_mainSwitcher;
  M13ProgressViewRing *_progressRing;
  
  UILabel * _dailyGoalText;
  UITextField *_dailyGoalNum;
  
  UILabel *_currentTallyText;
  UILabel *_currentTallyNum;
  
  NSMutableArray *_goals;
  
  int numCurrentValues;
  
  UITapGestureRecognizer *tap;
}

@end

@implementation GoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  //Load in all of the goals here
  _goals = [[DatabaseManager getSharedInstance] fetchAllGoals];
  
  int firstGoal = 10;
  
  if ([_goals count] == 0)
  {
    [[DatabaseManager getSharedInstance] addDefaultGoals];
  } else {
    firstGoal = ((WorkoutGoalObject *)(_goals[0])).number;
  }
  
  numCurrentValues = 3;
  
  _mainSwitcher = [[UISegmentedControl alloc] initWithItems:@[@"Push ups", @"Right Plank",  @"Left Plank", @"Situps"]];
  _mainSwitcher.frame = CGRectMake(0, 40, 100, 100);
  _mainSwitcher.selectedSegmentIndex = 0;
  [_mainSwitcher sizeToFit];

  [_mainSwitcher addTarget:self
                       action:@selector(selectedSegmentChanged)
             forControlEvents:UIControlEventValueChanged];
  
  [self.view addSubview:_mainSwitcher];
  
  _progressRing = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake(60, 140, 250, 250)];
  [_progressRing setProgress:((double)numCurrentValues / firstGoal) animated:YES];
  _progressRing.showPercentage = YES;
  [self.view addSubview:_progressRing];
  
  _dailyGoalText = [[UILabel alloc] initWithFrame:CGRectMake(100, 490, 200, 200)];
  _dailyGoalText.text = @"Daily Goal: ";
  [_dailyGoalText sizeToFit];
  [self.view addSubview:_dailyGoalText];
  
  _dailyGoalNum = [[UITextField alloc] initWithFrame:CGRectMake(_dailyGoalText.frame.origin.x + _dailyGoalText.frame.size.width, _dailyGoalText.frame.origin.y, 100, 100)];
  _dailyGoalNum.text = [NSString stringWithFormat:@"%i", firstGoal];
  [_dailyGoalNum sizeToFit];
  _dailyGoalNum.keyboardType = UIKeyboardTypeNumberPad;
  _dailyGoalNum.delegate = self;
  [self.view addSubview:_dailyGoalNum];
  
  _currentTallyText = [[UILabel alloc] initWithFrame:CGRectMake(100, 440, 200, 200)];
  _currentTallyText.text = @"Current Tally: ";
  [_currentTallyText sizeToFit];
  [self.view addSubview:_currentTallyText];
  
  _currentTallyNum = [[UILabel alloc] initWithFrame:CGRectMake(_currentTallyText.frame.origin.x + _currentTallyText.frame.size.width, _currentTallyText.frame.origin.y, 100, 100)];
  _currentTallyNum.text = @"3";
  [_currentTallyNum sizeToFit];
  [self.view addSubview:_currentTallyNum];
  
  tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  //[self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
  [_dailyGoalNum endEditing:YES];
  
  [self.view removeGestureRecognizer:tap];
}

-(void)keyboardWillShow {
  // Animate the current view out of the way
  [UIView animateWithDuration:0.3f animations:^ {
    self.view.frame = CGRectMake(0, -160, 320, 480);
  }];
  
 // tap = [[UITapGestureRecognizer alloc]
 //        initWithTarget:self
 //        action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
}

-(void)keyboardWillHide {
  // Animate the current view back to its original position
  [UIView animateWithDuration:0.3f animations:^ {
    self.view.frame = CGRectMake(0, 0, 320, 480);
  }];
}

-(void) selectedSegmentChanged
{
  if ([_goals count] == 0)
  {
     _goals = [[DatabaseManager getSharedInstance] fetchAllGoals];
  }
  
  _dailyGoalNum.text = [NSString stringWithFormat:@"%i", ((WorkoutGoalObject *)(_goals[_mainSwitcher.selectedSegmentIndex])).number];
  [_dailyGoalNum sizeToFit];
  [_progressRing setProgress:((double)numCurrentValues / [_dailyGoalNum.text intValue]) animated:YES];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
  [[DatabaseManager getSharedInstance] updateGoals:_mainSwitcher.selectedSegmentIndex withNewGoal: [textField.text intValue]];
  
  [_progressRing setProgress:((double)numCurrentValues / [textField.text intValue]) animated:YES];
  
  [((WorkoutGoalObject *)_goals[_mainSwitcher.selectedSegmentIndex]) setNumber:[textField.text intValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
