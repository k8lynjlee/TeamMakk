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
  UITapGestureRecognizer *touchTap;
  
  UIView* touchView;
  
  UIStepper *_goalStepper;
  
  int firstGoal;
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
  
  firstGoal = 10;
  
  if ([_goals count] == 0)
  {
    [[DatabaseManager getSharedInstance] addDefaultGoals];
  } else {
    firstGoal = ((WorkoutGoalObject *)(_goals[0])).number;
  }
  
  numCurrentValues = 3;
  
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  
  _mainSwitcher = [[UISegmentedControl alloc] initWithItems:@[@"Push ups", @"Right Plank",  @"Left Plank", @"Situps"]];
  _mainSwitcher.frame = CGRectMake(0, 40, 100, 100);
  _mainSwitcher.selectedSegmentIndex = 0;
  _mainSwitcher.tintColor = [UIColor redColor];
  [_mainSwitcher sizeToFit];
  
  _mainSwitcher.frame = CGRectMake((screenWidth - _mainSwitcher.frame.size.width)/2, 60, 100, 100);
  [_mainSwitcher sizeToFit];

  [_mainSwitcher addTarget:self
                       action:@selector(selectedSegmentChanged)
             forControlEvents:UIControlEventValueChanged];
  
  [self.view addSubview:_mainSwitcher];
  
  _progressRing = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake(60, 140, 250, 250)];
  [_progressRing setProgress:((double)numCurrentValues / firstGoal) animated:YES];
  _progressRing.showPercentage = YES;
  _progressRing.primaryColor = [UIColor orangeColor];
  _progressRing.secondaryColor = [UIColor redColor];
  [self.view addSubview:_progressRing];
  
  _dailyGoalText = [[UILabel alloc] initWithFrame:CGRectMake(20, 470, 80, 100)];
  _dailyGoalText.text = @"Goal ";
  _dailyGoalText.textAlignment = NSTextAlignmentRight;
  _dailyGoalText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
  //[_dailyGoalText sizeToFit];
  [self.view addSubview:_dailyGoalText];
  
  _dailyGoalNum = [[UITextField alloc] initWithFrame:CGRectMake(_dailyGoalText.frame.origin.x + _dailyGoalText.frame.size.width + 10, 471, 120, 100)];
  
  UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(20, 555, 400, 1)];
  grayLine.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:grayLine];
  
  UIView *grayLine3 = [[UIView alloc] initWithFrame:CGRectMake(20, 415, 400, 1)];
  grayLine3.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:grayLine3];
  
  _dailyGoalNum.text = [NSString stringWithFormat:@"%i", firstGoal];
  _dailyGoalNum.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.0];
  _dailyGoalNum.textColor = [UIColor redColor];
  //[_dailyGoalNum sizeToFit];
  _dailyGoalNum.keyboardType = UIKeyboardTypeDecimalPad;
  _dailyGoalNum.delegate = self;
  [self.view addSubview:_dailyGoalNum];
  
  _currentTallyText = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 80, 100)];
  _currentTallyText.text = @"Today ";
  _currentTallyText.textAlignment = NSTextAlignmentRight;
  _currentTallyText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
  //[_currentTallyText sizeToFit];
  
  UIView *grayLineTwo = [[UIView alloc] initWithFrame:CGRectMake(20, 485, 400, 1)];
  grayLineTwo.backgroundColor = [UIColor lightGrayColor];
  [self.view addSubview:grayLineTwo];
  
  
  _currentTallyNum = [[UILabel alloc] initWithFrame:CGRectMake(_currentTallyText.frame.origin.x + _currentTallyText.frame.size.width - 5, 380, 200, 160)];
  _currentTallyNum.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.0];
  _currentTallyNum.textColor = [UIColor grayColor];
  _currentTallyNum.text = @"3";
  //[_currentTallyNum sizeToFit];
  
 // _currentTallyText.frame = CGRectMake((screenWidth - _currentTallyText.frame.size.width - _currentTallyNum.frame.size.width)/2, 400, 100, 100);
  
  [self.view addSubview:_currentTallyText];
  
  _currentTallyNum.frame = CGRectMake(_currentTallyText.frame.origin.x + _currentTallyText.frame.size.width + 10, 427, 100, 100);
  
 // _currentTallyNum.text = @"3";
  [_currentTallyNum sizeToFit];
  [self.view addSubview:_currentTallyNum];
  
  tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
  
  touchView = [[UIView alloc] initWithFrame:CGRectMake(_dailyGoalNum.frame.origin.x - 10, _dailyGoalNum.frame.origin.y - 10, _dailyGoalNum.frame.size.width + 20 , _dailyGoalNum.frame.size.height + 20)];
  touchView.backgroundColor = [UIColor clearColor];
  touchView.alpha = 1.0;
  
  touchTap = [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(enableKeyboard)];
  
  [touchView addGestureRecognizer:touchTap];
  
  [self.view addSubview:touchView];
  
  _goalStepper = [[UIStepper alloc] initWithFrame:CGRectMake(162, 508, 150, 200)];
  _goalStepper.minimumValue = - (firstGoal);
  _goalStepper.maximumValue = 255 - firstGoal;
  [_goalStepper addTarget:self action:(@selector(stepperPressed)) forControlEvents:UIControlEventValueChanged];
  _goalStepper.tintColor = [UIColor redColor];
  [self.view addSubview:_goalStepper];

}

-(void) stepperPressed
{
  _dailyGoalNum.text = [NSString stringWithFormat:@"%i", firstGoal + (int)_goalStepper.value ];
  
  [_progressRing setProgress:((double)numCurrentValues / [_dailyGoalNum.text intValue]) animated:YES];
  
  [[DatabaseManager getSharedInstance] updateGoals:_mainSwitcher.selectedSegmentIndex withNewGoal: [_dailyGoalNum.text intValue]];
  
  [((WorkoutGoalObject *)_goals[_mainSwitcher.selectedSegmentIndex]) setNumber:[_dailyGoalNum.text intValue]];
}

-(void)enableKeyboard {
  NSLog(@"Did get touch");
  [_dailyGoalNum becomeFirstResponder];
  
  //[self.view removeGestureRecognizer:tap];
}

-(void)dismissKeyboard {
  NSLog(@"Did get touch");
  CGPoint location = [tap locationInView:self.view];
  
  //if ( abs(location.x - touchView.frame.origin.x) < touchView.frame.size.width)
  //{
  //  [self enableKeyboard];
  //} else {
  [_dailyGoalNum resignFirstResponder];
  [_dailyGoalNum endEditing:YES];
  //}
  
  //[self.view removeGestureRecognizer:tap];
}

-(void)keyboardWillShow {
  // Animate the current view out of the way
  [UIView animateWithDuration:0.3f animations:^ {
    self.view.frame = CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  }];
  
 // tap = [[UITapGestureRecognizer alloc]
 //        initWithTarget:self
 //        action:@selector(dismissKeyboard)];
  
 // [self.view addGestureRecognizer:tap];
}

-(void)keyboardWillHide {
  // Animate the current view back to its original position
  [UIView animateWithDuration:0.3f animations:^ {
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  }];
}

-(void) selectedSegmentChanged
{
  if ([_goals count] == 0)
  {
     _goals = [[DatabaseManager getSharedInstance] fetchAllGoals];
  }
  
  _dailyGoalNum.text = [NSString stringWithFormat:@"%i", ((WorkoutGoalObject *)(_goals[_mainSwitcher.selectedSegmentIndex])).number];
  //[_dailyGoalNum sizeToFit];
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
