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
@end

@implementation WorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
  self.button.backgroundColor = [UIColor redColor];
  [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.button];
    // Do any additional setup after loading the view.
  [[BluetoothShieldHelper sharedShieldHelper] setListener:self];
}

- (void)buttonPressed:(id)sender
{
  NSLog(@"Button pressed");
  [[BluetoothShieldHelper sharedShieldHelper]initDevice];
}

-(void) didReceiveMessageFromShield:(NSString *)message
{
  NSLog(@"Received message!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
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
