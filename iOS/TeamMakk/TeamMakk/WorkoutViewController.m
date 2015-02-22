//
//  WorkoutViewController.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "WorkoutViewController.h"
#import "CounterView.h"
#import "DatabaseManager.h"
#import "WorkoutGoalObject.h"



@interface WorkoutViewController () {
  CounterView *_counterView;
  
  int numWorkout;
  
  NSArray *_goalArray;
}
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *workoutLabel;
@property (nonatomic, strong) UILabel *counterLabel;
@end

@implementation WorkoutViewController

-(void) initWithGoals: (NSArray *)goals
{
  _goalArray = goals;
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.navigationController.navigationBar.topItem.title = @"Workouts";
  
  _goalArray = [[DatabaseManager getSharedInstance] fetchAllGoals];
  
  if ([_goalArray count] == 0)
  {
    [[DatabaseManager getSharedInstance] addDefaultGoals];
    _goalArray = [[DatabaseManager getSharedInstance] fetchAllGoals];
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  /*self.button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
  self.button.backgroundColor = [UIColor redColor];
  [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.button];*/
  
  UIImageView * pushupGif = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
  pushupGif.image = [UIImage imageNamed:@"pushups.gif"];
  //[pushupGif startAnimating];
  
  UIScrollView * horizontalScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 350)];
  [horizontalScroll addSubview:pushupGif];
  
  //[self.view addSubview:horizontalScroll];
  
  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  
  self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.button.frame = CGRectMake(250, 200, 100, 30);
//  self.button = [[UIButton alloc] initWithFrame:CGRectMake(250, 100, 100, 30)];
  [self.button setTitle:@"Start" forState:UIControlStateNormal];
  //[self.button addTarget:self action:@selector(buttonPressedMessage:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.button sizeToFit];
  self.button.frame = CGRectMake( (screenWidth - self.button.frame.size.width)/2, 200, 100, 30);
  [self.button sizeToFit];
  
  //[self.view addSubview:self.button];
  
    // Do any additional setup after loading the view.
  
  /*_workoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 100, 30)];
  _workoutLabel.text = @"No workout now";
  [_workoutLabel sizeToFit];
  //[self.view addSubview:_workoutLabel];
  */
  _counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 560, 100, 30)];
  //_counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 560, 100, 50)];
  _counterLabel.text = @"0";
  //[self.view addSubview:_counterLabel];
  _counterView = [[CounterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)) exercise:@"Activate" delegate:self];
 // _counterView = [[CounterView alloc] initWithFrame:CGRectMake(50, 400, 200, 150) exercise:@"Activate"];
  
  /*UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressedMessage:)];
  //tapRecognizer.delegate = self;
  [_counterView addGestureRecognizer:tapRecognizer];*/
  
  [self.view addSubview:_counterView];
  
  [[BluetoothShieldHelper sharedShieldHelper] setListener:self];
  
}

- (void)updateCounter {
  [_counterView increaseCount];
}

- (void)buttonPressedMessage:(id)sender
{
  //NSLog(@"Button pressed");
  //[_counterView setTitle:@"Get in position"];
  //[_counterView userHasStarted];
  [[BluetoothShieldHelper sharedShieldHelper]sendControlMessage: _goalArray];
}

-(void) didReceiveMessageFromShield:(NSString *)message
{
  NSLog(@"Received message!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

-(void) didStartWorkout: (int) workoutNumber
{
  if (workoutNumber == 1) {
    //Pushup
    _workoutLabel.text = @"Pushup";
    [_counterView setTitle:@"Pushup"];
  } else if (workoutNumber == 2) {
    //R Plank
    _workoutLabel.text = @"R Plank";
    [_counterView setTitle:@"R Plank"];
    [_counterView startTimer];
  } else if (workoutNumber == 3) {
    //L Plank
    _workoutLabel.text = @"L Plank";
    [_counterView setTitle:@"L Plank"];
    [_counterView startTimer];
  } else if (workoutNumber == 4){
    //Situp
    _workoutLabel.text = @"Situp";
    [_counterView setTitle:@"Situp"];
  }
  
  [_counterView setGoal:((WorkoutGoalObject *)_goalArray[workoutNumber - 1]).number];
}

-(void) didEndWorkout: (int) workoutNumber
{
  if ((workoutNumber == 2) || (workoutNumber == 3))
  {
    //NumWorkouts its coming from the timer in the counterview
    numWorkout = [_counterView getElapsedTime];
  }
  
  _workoutLabel.text = @"No workout (END)";
  [_counterView userHasFinished];
  //[_counterView setGoal:0];
  //[_counterView setTitle:@""];
  
  //[_counterView endTimer];
  
  //[_counterView resetLabels];
  
  // Save the workout that we just did
  NSLog(@"Logging the following workout: %i for %i reps", (workoutNumber-1), numWorkout);
  [[DatabaseManager getSharedInstance]saveExercise:(workoutNumber-1) numberOfReps:numWorkout date:[NSDate date]];
  
  //Force table reload
  
}

-(void) didReceiveWorkoutNumberUpdate: (int) workoutUpdate
{
  _counterLabel.text = [NSString stringWithFormat:@"%i", workoutUpdate];
  if (_counterView.isCounter) {
    [self updateCounter];
  }
  numWorkout = workoutUpdate;
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
