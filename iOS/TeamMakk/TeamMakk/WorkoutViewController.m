//
//  WorkoutViewController.m
//  TeamMakk
//
//  Created by Kaitlyn Lee on 2/21/15.
//  Copyright (c) 2015 teammakk. All rights reserved.
//

#import "WorkoutViewController.h"

@interface WorkoutViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *workoutLabel;
@property (nonatomic, strong) UILabel *counterLabel;
@end

@implementation WorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
  self.button.backgroundColor = [UIColor redColor];
  [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.button];
  
  self.button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 30)];
  self.button.backgroundColor = [UIColor blueColor];
  [self.button addTarget:self action:@selector(buttonPressedMessage:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.button];
    // Do any additional setup after loading the view.
  [[BluetoothShieldHelper sharedShieldHelper] setListener:self];
  
  _workoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 100, 30)];
  _workoutLabel.text = @"No workout now";
  [_workoutLabel sizeToFit];
  [self.view addSubview:_workoutLabel];
  
  _counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 400, 100, 30)];
  _counterLabel.text = @"0";
  [self.view addSubview:_counterLabel];
}

- (void)buttonPressed:(id)sender
{
  NSLog(@"Button pressed");
  [[BluetoothShieldHelper sharedShieldHelper]initDevice];
}

- (void)buttonPressedMessage:(id)sender
{
  NSLog(@"Button pressed");
  [[BluetoothShieldHelper sharedShieldHelper]sendControlMessage];
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
  } else if (workoutNumber == 2) {
    //R Plank
    _workoutLabel.text = @"R Plank";
  } else if (workoutNumber == 3) {
    //L Plank
    _workoutLabel.text = @"L Plank";
  } else if (workoutNumber == 4){
    //Situp
    _workoutLabel.text = @"Situp";
  }
}

-(void) didEndWorkout: (int) workoutNumber
{
  _workoutLabel.text = @"No workout (END)";
}

-(void) didReceiveWorkoutNumberUpdate: (int) workoutUpdate
{
  _counterLabel.text = [NSString stringWithFormat:@"%i", workoutUpdate];
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
